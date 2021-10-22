defmodule AppWeb.UserLive.Edit do
  use AppWeb, :surface_live_view

  alias App.{Accounts, Accounts.User, Repo}
  alias LeftSidebarLayout.Layout

  alias AppWeb.UserLive.Edit.Components.{
    Menu,
    ChangePassword,
    ChangeEmail,
    EditProfile,
    Notifications
  }

  data current_user, :any
  data changeset, :any
  data sign_in_token, :string

  def mount(%{"id" => id}, session, socket) do
    {:ok,
     socket
     |> assign(%{
       profile_user: Accounts.get_user!(id),
       page_title: "Settings"
     })
     |> require_current_user(session)}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, socket |> apply_action(socket.assigns.live_action, params)}
  end

  def apply_action(socket, :index, _params),
    do:
      assign(
        socket,
        %{
          changeset: build_changeset(socket.assigns.current_user, socket.assigns.profile_user),
          page_title: "Edit profile"
        }
      )

  def apply_action(socket, :change_email, _params),
    do:
      assign(socket, %{
        changeset: App.Accounts.change_user_email(socket.assigns.profile_user),
        page_title: "Change email"
      })

  def apply_action(socket, :change_password, _params),
    do:
      assign(socket, %{
        changeset: App.Accounts.change_user_password(socket.assigns.profile_user),
        page_title: "Change password"
      })

  def apply_action(socket, :notifications, _params),
    do:
      assign(socket, %{
        changeset: build_changeset(socket.assigns.current_user, socket.assigns.profile_user),
        notification_fields: User.notification_fields(),
        page_title: "Notifications"
      })

  def render(assigns) do
    ~F"""
    <div class="flex flex-col h-screen bg-gray-100 dark:bg-gray-900">
      <Nav id="nav" current_user={@current_user} active_page={:settings} />

      <PageBanner
        container_max_width="lg"
        title="Settings"
        subtitle={@profile_user.name}
        text_class="text-white"
        bg_class="shadow bg-secondary-900"
      >
        <:left_content>
          <div class="flex items-center justify-center flex-none rounded-full bg-secondary-600 w-14 h-14">
            <svg class="w-8 h-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
              />
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
              />
            </svg>
          </div>
        </:left_content>
      </PageBanner>

      <Container max_width="lg" class="w-full mt-0 md:mt-8">
        <Layout>
          <:sidebar>
            <Menu live_action={@live_action} profile_user={@profile_user} />
          </:sidebar>

          <EditProfile
            :if={@live_action == :index}
            changeset={@changeset}
            user={@profile_user}
          />

          <ChangeEmail
            :if={@live_action == :change_email}
            changeset={@changeset}
          />

          <ChangePassword
            :if={@live_action == :change_password}
            changeset={@changeset}
          />

          <Notifications
            :if={@live_action == :notifications}
            changeset={@changeset}
            notification_fields={@notification_fields}
          />

          <Link
            label={"Delete #{if @current_user == @profile_user, do: "your", else: "this"} account"}
            to={Routes.user_settings_path(@socket, :delete_user, @profile_user)}
            method={:delete}
            class="inline-block mt-5 text-sm text-gray-500 hover:underline"
            opts={
              "data-confirm":
                "Are you sure you want to delete #{if @current_user == @profile_user, do: "your", else: "this"} account?"
            }
          />
        </Layout>
      </Container>
    </div>
    """
  end

  def handle_event("update_form", %{"user" => user_params}, socket) do
    %{profile_user: profile_user, current_user: current_user} = socket.assigns
    changeset = build_changeset(current_user, profile_user, user_params)
    {:noreply, assign(socket, %{changeset: changeset})}
  end

  def handle_event("submit", %{"user" => user_params}, socket) do
    %{profile_user: profile_user, current_user: current_user} = socket.assigns
    changeset = build_changeset(current_user, profile_user, user_params)

    case Repo.update(changeset) do
      {:ok, profile_user} ->
        socket =
          socket
          |> put_flash(:success, "Profile updated")
          |> assign(%{
            changeset: build_changeset(current_user, profile_user),
            profile_user: profile_user
          })

        create_log_and_mailbluster_sync(current_user, profile_user)
        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> put_flash(:error, "Please enter the required fields.")
          |> assign(%{changeset: changeset})

        {:noreply, socket}
    end
  end

  def handle_event(
        "update-email",
        %{"user" => %{"current_password" => current_password} = user_params},
        socket
      ) do
    user = socket.assigns.profile_user

    case Accounts.apply_user_email(user, current_password, user_params) do
      {:ok, user} ->
        Accounts.deliver_update_email_instructions(
          user,
          user.email,
          &Routes.user_settings_url(socket, :confirm_email, &1)
        )

        {:noreply,
         put_flash(
           socket,
           :info,
           "A link to confirm your e-mail change has been sent to the new address."
         )}

      {:error, changeset} ->
        {:noreply, assign(socket, %{changeset: changeset})}
    end
  end

  def handle_event("file_uploaded", %{"public_id" => cloudinary_id}, socket) do
    %{profile_user: profile_user, current_user: current_user} = socket.assigns

    case build_changeset(current_user, profile_user, %{
           avatar_cloudinary_id: cloudinary_id
         })
         |> Repo.update() do
      {:ok, profile_user} ->
        create_log_and_mailbluster_sync(current_user, profile_user)

        socket =
          socket
          |> put_flash(
            :success,
            "Profile picture saved."
          )
          |> assign(%{profile_user: profile_user})

        # Ensure navbar updates with new icon
        socket =
          if current_user.id == profile_user.id do
            assign(socket, %{current_user: profile_user})
          else
            socket
          end

        {:noreply, socket}

      {:error, _changeset} ->
        socket =
          socket
          |> put_flash(
            :error,
            "There was a problem adding your profile picture. Please try again."
          )

        {:noreply, socket}
    end
  end

  def handle_event("delete_avatar", _params, socket) do
    %{profile_user: profile_user, current_user: current_user} = socket.assigns

    case build_changeset(current_user, profile_user, %{
           avatar_cloudinary_id: nil
         })
         |> Repo.update() do
      {:ok, profile_user} ->
        create_log_and_mailbluster_sync(current_user, profile_user)

        socket =
          socket
          |> put_flash(:success, "Profile picture removed.")
          |> assign(%{profile_user: profile_user})

        # Ensure navbar updates with new icon
        socket =
          if current_user.id == profile_user.id do
            assign(socket, %{current_user: profile_user})
          else
            socket
          end

        {:noreply, socket}

      {:error, _changeset} ->
        socket =
          socket
          |> put_flash(
            :error,
            "There was a problem removing your profile picture. Please refresh and try again."
          )

        {:noreply, socket}
    end
  end

  defp build_changeset(current_user, user, params \\ %{})

  defp build_changeset(nil, _, _), do: nil

  defp build_changeset(%User{is_moderator: true} = _current_user, user, params),
    do: Accounts.User.moderator_changeset(user, params)

  defp build_changeset(
         %User{id: id, is_moderator: false} = _current_user,
         %User{id: id} = user,
         params
       ),
       do: Accounts.User.profile_changeset(user, params)

  defp build_changeset(_, _, _), do: nil

  defp create_log_and_mailbluster_sync(user_who_did_updating, user_who_was_updated) do
    App.Logs.log_async("update_profile", %{
      user: user_who_did_updating,
      target_user: user_who_was_updated
    })

    App.MailBluster.sync_user_async(user_who_was_updated)
  end
end

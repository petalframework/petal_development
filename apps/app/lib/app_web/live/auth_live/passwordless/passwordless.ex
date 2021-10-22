defmodule AppWeb.AuthLive.Passwordless do
  use AppWeb, :surface_live_view
  alias App.{Repo, Accounts}
  alias App.Accounts.{User, UserNotifier, UserToken}

  alias AppWeb.AuthLive.Passwordless.Components.{
    SignIn,
    SignInCode,
    Register
  }

  @allowed_attempts 3

  data user_return_to, :string
  data registration_changeset, :any
  data error_message, :string, default: ""
  data auth_user, :any, default: nil
  data email, :string, default: ""
  data pin_sent?, :boolean, default: false
  data submit_sign_in?, :boolean, default: false
  data submit_register?, :boolean, default: false
  data base64_token, :any, default: nil
  data enable_resend?, :boolean, default: false
  data attempts, :integer, default: 0

  def mount(params, _session, socket) do
    socket =
      assign(socket,
        registration_changeset: build_registration_changeset(),
        user_return_to: Map.get(params, "user_return_to", nil)
      )

    socket =
      if Mix.env() == :dev do
        assign(socket, email: "admin@test.com")
      else
        socket
      end

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :sign_in, _params), do: socket
  defp apply_action(socket, :register, _params), do: socket

  defp apply_action(socket, :sign_in_code, %{"user_id" => user_id}) do
    if socket.assigns.auth_user do
      socket
    else
      # Re-assign page variables if this is remounted (eg. socket disconnected)
      # This can happen on mobile devices when user switches to mail app to copy/paste pin code
      auth_user = Accounts.get_user!(user_id)

      if UserToken.valid_passwordless_pin_exists?(auth_user) do
        assign(socket,
          auth_user: auth_user,
          pin_sent?: true,
          email: auth_user.email
        )
      else
        # Delay redirecting so the sign_in page doesn't flash when signing in
        # This is because AppWeb.UserAuth.log_in_user causes a remount to occur prior to redirecting to home page
        :timer.sleep(1000)

        socket
        |> push_patch(to: Routes.auth_passwordless_path(socket, :sign_in))
      end
    end
  end

  def render(assigns) do
    ~F"""
    <div class="flex flex-col h-screen bg-gray-100 dark:bg-gray-900">
      <Nav id="nav" active_page={active_page(@live_action)} />

      <SignIn
        :if={!@pin_sent? and @live_action == :sign_in}
        email={@email}
        user_return_to={@user_return_to}
        error_message={@error_message}
      />

      <div
        id="logging_in_text"
        style="display: none;"
        class="flex flex-col justify-center py-12 mt-10 sm:px-6 lg:px-8"
      >
        <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
          <div class="px-4 py-8 bg-white shadow dark:bg-gray-800 sm:rounded-lg sm:px-10">
            Logging in...
          </div>
        </div>
      </div>

      <SignInCode
        :if={@pin_sent? and @live_action == :sign_in_code}
        submit_sign_in?={@submit_sign_in?}
        enable_resend?={@enable_resend?}
        error_message={@error_message}
        user_return_to={@user_return_to}
        email={@email}
        base64_token={@base64_token}
      />

      <Register
        :if={@live_action == :register}
        registration_changeset={@registration_changeset}
        user_return_to={@user_return_to}
      />
    </div>
    """
  end

  def handle_event("validate_register", %{"user" => attrs}, socket) do
    changeset =
      %User{}
      |> build_registration_changeset(attrs)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, :registration_changeset, changeset)}
  end

  # Step 1: signing-in is to submit the email.
  def handle_event("submit_email", %{"user" => %{"email" => email}}, socket) do
    send_pin(socket, email)
  end

  # Step 2: enter a 6 digit pin.
  def handle_event("validate_pin", %{"user" => %{"pin" => pin}}, socket)
      when byte_size(pin) < 6 do
    {:noreply, assign(socket, %{error_message: nil})}
  end

  # Handle nil user
  def handle_event("validate_pin", %{"user" => %{"pin" => _pin}}, socket)
      when socket.assigns.auth_user == nil do
    {:noreply, assign(socket, %{error_message: nil})}
  end

  def handle_event("validate_pin", %{"user" => %{"pin" => submitted_pin}}, socket)
      when byte_size(submitted_pin) >= 6 do
    submitted_pin = String.trim(submitted_pin)

    case UserToken.check_passwordless_pin(socket.assigns.auth_user, submitted_pin) do
      nil ->
        IO.inspect("Attempts: #{socket.assigns.attempts + 1}/#{@allowed_attempts}")

        if socket.assigns.attempts >= @allowed_attempts do
          # Delete the user_token holding the pin
          UserToken.clear_passwordless_pins(socket.assigns.auth_user)

          App.Logs.log_async("pin_code_too_many_incorrect_attempts", %{
            user: socket.assigns.auth_user
          })

          socket =
            push_redirect(socket, to: "/")
            |> put_flash(:error, "Too many incorrect attempts.")

          {:noreply, socket}
        else
          {:noreply,
           assign(socket, %{
             error_message: "Not a valid code. Sure you typed it correctly?",
             attempts: socket.assigns.attempts + 1
           })}
        end

      _user_token ->
        IO.inspect("Matched")

        base64_token =
          socket.assigns.auth_user
          |> Accounts.generate_user_session_token()
          |> Base.encode64()

        {:noreply,
         assign(socket, %{
           # Development notes:
           # 1. We don't use phx_trigger_action because it resulted in the form sometimes being submitted before the DOM is patched with the base64_token
           # 2. To guarantee base64_token is set in the form before submitting, we use a JS event "auth_live_sign_in" in AuthLiveSignInHook to set the token and submit the form
           # 3. To revert to the phx_trigger_action method: uncomment the two lines below and comment out the |> push_event
           # submit_sign_in?: true,
           # base64_token: base64_token,
           error_message: nil
         })
         |> push_event("passwordless_sign_in", %{
           user_base64_token: base64_token,
           user_return_to: socket.assigns[:user_return_to]
         })}
    end
  end

  # Fallback function if the pin wasn't yet 6 digits.
  def handle_event("validate_pin", _, socket),
    do: {:noreply, socket}

  def handle_event("trigger_sign_in", _, socket) do
    if socket.assigns.base64_token do
      {:noreply, assign(socket, %{submit_sign_in?: true})}
    else
      {:noreply, assign(socket, %{error_message: "Incorrect pin."})}
    end
  end

  def handle_event("allow_submit_register", %{"user" => user_params}, socket) do
    case Accounts.get_user_by_email(Map.get(user_params, "email", "")) do
      nil ->
        register_user(socket, user_params)

      user ->
        send_pin(socket, user.email)
    end
  end

  def handle_event("resend", _, socket) do
    user = socket.assigns[:auth_user]

    if user do
      {:ok, %{user_token: %{token: pin}}} = UserToken.create_passwordless_pin(user)
      UserNotifier.deliver_sign_in_pin_instructions(user, pin)

      {:noreply,
       assign(socket, %{
         pin_sent?: true,
         enable_resend?: false,
         error_message: nil
       })}
    else
      {:noreply, socket}
    end
  end

  defp send_pin(socket, email) do
    email = Util.trim(email)

    with {:ok, user} <- find_user(email),
         :not_suspended <- user_suspended?(user),
         {:ok, %{user_token: %{token: pin}}} <- UserToken.create_passwordless_pin(user) do
      UserNotifier.deliver_sign_in_pin_instructions(user, pin)
      App.Logs.log_async("pin_code_sent", %{user: user})

      if Mix.env() == :dev do
        IO.inspect("----------- PIN ------------")
        IO.inspect(pin)
      end

      {:noreply,
       assign(socket, %{
         pin_sent?: true,
         email: email,
         error_message: nil,
         auth_user: user,
         attempts: 0
       })
       |> push_patch(to: Routes.auth_passwordless_path(socket, :sign_in_code, user))}
    else
      {:error, :email_is_blank} ->
        {:noreply, assign(socket, error_message: "Please enter the email you signed up with")}

      {:error, :user_not_found} ->
        if Util.email_valid?(email) do
          {:noreply,
           assign(socket,
             error_message:
               raw("We couldn't locate your account.<br>Sure you typed it correctly?"),
             email: email
           )}
        else
          {:noreply,
           assign(socket,
             error_message:
               raw("That doesn't look like a valid email.<br>Sure you typed it correctly?"),
             email: email
           )}
        end

      :suspended ->
        {:noreply,
         assign(socket,
           error_message: "There was a problem signing into your account. Please try again later."
         )}

      _ ->
        {:noreply, assign(socket, error_message: "Unknown error.")}
    end
  end

  defp register_user(socket, user_params) do
    changeset = build_registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        App.Logs.log_async("register", %{user: user})
        send_pin(socket, user.email)

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, %{registration_changeset: changeset})}
    end
  end

  defp user_suspended?(%{is_suspended: true}), do: :suspended
  defp user_suspended?(_), do: :not_suspended

  defp find_user(email) do
    if email == "" do
      {:error, :email_is_blank}
    else
      case Accounts.get_user_by_email(email) do
        nil ->
          {:error, :user_not_found}

        user ->
          {:ok, user}
      end
    end
  end

  defp active_page(:sign_in), do: :sign_in
  defp active_page(:register), do: :register
  defp active_page(:sign_in_code), do: :sign_in
  defp active_page(_), do: nil

  defp build_registration_changeset() do
    if Mix.env() == :dev do
      Accounts.change_user_passwordless_registration(%User{
        name: "Bob Smith",
        email: "bob@test.com"
      })
    else
    end
  end

  defp build_registration_changeset(user, attrs),
    do: Accounts.change_user_passwordless_registration(user, attrs)
end

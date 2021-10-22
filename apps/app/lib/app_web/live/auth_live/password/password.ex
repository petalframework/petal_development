defmodule AppWeb.AuthLive.Password do
  use AppWeb, :surface_live_view
  alias App.{Accounts, Repo}
  alias App.Accounts.{User, UserNotifier}

  alias AppWeb.AuthLive.Password.Components.{
    SignInTokenForm,
    UserDetailsForm,
    ValidationCodeForm,
    EmailForm,
    SignInForm,
    AuthLayout
  }

  data error_message, :any, default: nil
  data changeset, :any, default: nil
  data email, :string
  data sign_in_token, :string
  data email_validated, :boolean, default: false
  data email_validation_code, :string
  data user_return_to, :string

  def mount(params, _session, socket) do
    socket =
      assign(socket, %{
        user_return_to: Map.get(params, "user_return_to", nil)
      })

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def render(%{live_action: :register} = assigns) do
    ~F"""
    <AuthLayout nav_active_page={:register} heading="Register" error_message={@error_message}>
      <:subheading>
        Already have an account?
        <LiveRedirect
          to={UserAuth.sign_in_path()}
          label="Sign in"
          class="font-medium transition duration-150 ease-in-out dark:text-secondary-500 text-secondary-600 dark:hover:text-secondary-400 hover:text-secondary-500 focus:outline-none focus:underline"
        />
      </:subheading>

      <EmailForm :if={!assigns[:email]} />
      <ValidationCodeForm :if={assigns[:email_validation_code]} email_sent_to={@email} />
      <UserDetailsForm :if={@changeset} changeset={@changeset} />
    </AuthLayout>
    """
  end

  def render(%{live_action: :sign_in} = assigns) do
    ~F"""
    <AuthLayout nav_active_page={:sign_in} heading="Sign in" error_message={@error_message}>
      <:subheading>
        Don't have an account?
        <LiveRedirect
          to={UserAuth.register_path()}
          label="Register"
          class="font-medium transition duration-150 ease-in-out dark:text-secondary-500 text-secondary-600 dark:hover:text-secondary-400 hover:text-secondary-500 focus:outline-none focus:underline"
        />
      </:subheading>
      <SignInForm />
    </AuthLayout>
    """
  end

  def render(%{live_action: :signing_in} = assigns) do
    ~F"""
    <AuthLayout nav_active_page={:sign_in} heading="Signing in...">
      <SignInTokenForm sign_in_token={assigns[:sign_in_token]} user_return_to={assigns[:user_return_to]} />
    </AuthLayout>
    """
  end

  def handle_event("submit_email", %{"user" => %{"email" => email}}, socket) do
    email = Util.trim(email)

    socket =
      case Repo.get_by(User, email: email) do
        nil ->
          if EmailChecker.valid?(email) do
            email_validation_code = Enum.random(100_0..900_0) |> Integer.to_string()
            UserNotifier.deliver_register_pin_instructions(email, email_validation_code)
            if Mix.env() == :dev, do: IO.inspect("Code: #{email_validation_code}")

            socket
            |> assign(%{
              email_validation_code: email_validation_code,
              email: email,
              error_message: nil
            })
          else
            assign(socket, :error_message, "Please enter a valid email to proceed.")
          end

        _ ->
          assign(socket, :error_message, "You already have an account. Please sign in.")
      end

    {:noreply, socket}
  end

  def handle_event("submit_email_validation_code", %{"user" => %{"code" => code}}, socket) do
    code = Util.trim(code)

    if code == socket.assigns.email_validation_code do
      {:noreply,
       assign(socket, %{
         error_message: nil,
         email_validation_code: nil,
         changeset: Accounts.change_user_registration(%User{}, %{email: socket.assigns.email})
       })}
    else
      {:noreply, assign(socket, :error_message, "Incorrect code, please try again.")}
    end
  end

  def handle_event("register", %{"user" => user_params}, socket) do
    user_params = Map.merge(user_params, %{"email" => socket.assigns.email})

    case Accounts.register_user(user_params) do
      {:ok, user} ->
        App.Logs.log_async("register", %{user_id: user.id})

        sign_in_token =
          user
          |> Accounts.generate_user_session_token()
          |> Base.encode64()

        {:ok, _updated_user} =
          user
          |> User.confirm_changeset()
          |> Repo.update()

        socket =
          socket
          |> assign(%{sign_in_token: sign_in_token, changeset: nil})
          |> push_patch(to: Routes.auth_password_path(socket, :signing_in))

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, %{changeset: changeset})}
    end
  end

  def handle_event("start_over", _, socket) do
    {:noreply,
     assign(socket, %{
       email: nil,
       email_validation_code: nil,
       email_validated: false,
       changeset: nil
     })}
  end

  def handle_event("sign-in", %{"user" => %{"email" => email, "password" => password}}, socket) do
    if user = Accounts.get_user_by_email_and_password(email, password) do
      sign_in_token =
        user
        |> Accounts.generate_user_session_token()
        |> Base.encode64()

      socket =
        socket
        |> assign(%{sign_in_token: sign_in_token})
        |> push_patch(to: Routes.auth_password_path(socket, :signing_in))

      {:noreply, socket}
    else
      {:noreply, assign(socket, %{error_message: "Invalid e-mail or password"})}
    end
  end
end

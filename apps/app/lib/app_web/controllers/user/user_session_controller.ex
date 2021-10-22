defmodule AppWeb.UserSessionController do
  use AppWeb, :controller

  alias App.Accounts
  alias AppWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      render(conn, "new.html", error_message: "Invalid e-mail or password")
    end
  end

  def token_sign_in(conn, %{"user" => %{"base64_token" => base64_token}} = params) do
    # We send the user's token straight from AppWeb.AuthLive
    token = Base.decode64!(base64_token)

    case Accounts.get_user_by_session_token(token) do
      nil ->
        conn
        |> put_flash(:error, "Sign in failed. Please try again")
        |> redirect(to: AppWeb.UserAuth.sign_in_path())

      user ->
        user_return_to = Map.get(params, "user_return_to", nil)

        conn =
          if user_return_to, do: put_session(conn, :user_return_to, user_return_to), else: conn

        # delete the session token as we create a new one in log_in_user
        Accounts.delete_session_token(token)

        # delete any passwordless pins
        App.Accounts.UserToken.clear_passwordless_pins(user)

        UserAuth.log_in_user(conn, user)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end

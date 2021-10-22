defmodule AppWeb.UserAuth do
  import Plug.Conn
  import Phoenix.Controller
  require Logger

  alias App.{Accounts, Repo}
  alias AppWeb.Router.Helpers, as: Routes

  # Make the remember me cookie valid for 60 days.
  # If you want bump or reduce this value, also change
  # the token expiry itself in UserToken.
  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "user_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  # In case you wish to change your type of auth (eg from password to passwordless)
  # Easier to have one location for the auth routes
  def register_path, do: Routes.auth_passwordless_path(AppWeb.Endpoint, :register)
  def sign_in_path, do: Routes.auth_passwordless_path(AppWeb.Endpoint, :sign_in)
  # def register_path, do: Routes.auth_password_password_path(AppWeb.Endpoint, :register)
  # def sign_in_path, do: Routes.auth_password_password_path(AppWeb.Endpoint, :sign_in)

  @doc """
  Logs the user in.

  It renews the session ID and clears the whole session
  to avoid fixation attacks. See the renew_session
  function to customize this behaviour.

  It also sets a `:live_socket_id` key in the session,
  so LiveView sessions are identified and automatically
  disconnected on log out. The line can be safely removed
  if you are not using LiveView.
  """
  def log_in_user(conn, user, params \\ %{}) do
    token = Accounts.generate_user_session_token(user)
    user_return_to = get_session(conn, :user_return_to)
    {:ok, user} = Accounts.update_last_signed_in_info(user, get_ip(conn))

    App.Logs.log_async("sign_in", %{user: user})
    App.MailBluster.sync_user_async(user)

    conn =
      conn
      |> renew_session()
      |> put_flash(:info, "You are now signed in")
      |> put_session(:user_token, token)
      |> put_session(:user_return_to, nil)
      |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
      |> maybe_write_remember_me_cookie(token, params)

    try do
      redirect(conn, to: user_return_to || signed_in_path(conn))
    rescue
      ArgumentError ->
        redirect(conn, to: signed_in_path(conn))
    end
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing, for example:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Logs the user out.

  It clears all session data for safety. See renew_session.
  """
  def log_out_user(conn) do
    user_token = get_session(conn, :user_token)

    if user_token do
      App.Logs.log_async("logout", %{
        user: Accounts.get_user_by_session_token(user_token)
      })

      Accounts.delete_session_token(user_token)
    end

    if live_socket_id = get_session(conn, :live_socket_id) do
      AppWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: "/")
  end

  @doc """
  Authenticates the user by looking into the session
  and remember me token.
  """
  def fetch_current_user(conn, _opts) do
    {user_token, conn} = ensure_user_token(conn)
    user = user_token && Accounts.get_user_by_session_token(user_token)
    assign(conn, :current_user, user)
  end

  defp ensure_user_token(conn) do
    if user_token = get_session(conn, :user_token) do
      {user_token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if user_token = conn.cookies[@remember_me_cookie] do
        {user_token, put_session(conn, :user_token, user_token)}
      else
        {nil, conn}
      end
    end
  end

  @doc """
  Used for routes that require the user to not be authenticated.
  """
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the user to be authenticated.

  If you want to enforce the user e-mail is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: sign_in_path())
      |> halt()
    end
  end

  @doc """
  Used for routes that require the user to be a super admin.
  """
  def require_moderator_user(conn, _opts) do
    if conn.assigns[:current_user] && conn.assigns[:current_user].is_moderator do
      conn
    else
      conn
      |> put_flash(:error, "You must be super admin to access this page.")
      |> redirect(to: signed_out_path(conn))
      |> halt()
    end
  end

  def can_edit_user?(conn, _) do
    current_user = conn.assigns.current_user
    user_to_edit_id = conn.params["id"]

    if "#{current_user.id}" == "#{user_to_edit_id}" || current_user.is_moderator do
      conn
    else
      conn
      |> put_flash(:error, "You do not have permission to edit this.")
      |> redirect(to: "/")
      |> halt()
    end
  end

  @doc """
  Disconnect a user from any logged in sockets.
  Useful when suspending or deleting a user to prevent them from clicking around while in a socket connection.
  """
  def log_out_another_user(user) do
    Logger.info("Logging out user id #{user.id} ... ")
    users_tokens = Accounts.UserToken.user_and_contexts_query(user, ["session"]) |> Repo.all()

    for user_token <- users_tokens do
      Logger.info("Deleting session token id #{user_token.id} ... ")
      Accounts.delete_session_token(user_token.token)
      live_socket_id = "users_sessions:#{Base.url_encode64(user_token.token)}"
      Logger.info("Disconnecting user id #{user.id}, live_socket_id: #{live_socket_id} ...")
      AppWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    %{request_path: request_path, query_string: query_string} = conn
    return_to = if query_string == "", do: request_path, else: request_path <> "?" <> query_string
    put_session(conn, :user_return_to, return_to)
  end

  defp maybe_store_return_to(conn), do: conn

  defp signed_out_path(conn), do: Routes.public_landing_page_path(conn, :index)
  defp signed_in_path(conn), do: Routes.public_landing_page_path(conn, :index)

  defp get_ip(conn) do
    # When behind a load balancer, the client ip is provided in the x-forwarded-for header
    # examples:
    # X-Forwarded-For: 2001:db8:85a3:8d3:1319:8a2e:370:7348
    # X-Forwarded-For: 203.0.113.195
    # X-Forwarded-For: 203.0.113.195, 70.41.3.18, 150.172.238.178
    forwarded_for = List.first(Plug.Conn.get_req_header(conn, "x-forwarded-for"))

    if forwarded_for do
      String.split(forwarded_for, ",")
      |> Enum.map(&String.trim/1)
      |> List.first()
    else
      to_string(:inet_parse.ntoa(conn.remote_ip))
    end
  end
end

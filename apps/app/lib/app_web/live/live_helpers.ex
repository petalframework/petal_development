defmodule AppWeb.LiveHelpers do
  import Phoenix.LiveView
  alias App.{Accounts, Accounts.User}
  alias AppWeb.UserAuth

  def is_connected?(socket), do: connected?(socket)

  def maybe_assign_current_user(socket, %{"user_token" => user_token})
      when is_binary(user_token) do
    assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(user_token) end)
  end

  def maybe_assign_current_user(socket, _session), do: assign(socket, current_user: nil)

  def require_current_user(socket, params) do
    socket = maybe_assign_current_user(socket, params)

    case socket.assigns.current_user do
      %User{} -> socket
      _else -> handle_require_sign_in(socket)
    end
  end

  def require_moderator(socket, params) do
    socket = maybe_assign_current_user(socket, params)

    if socket.assigns[:current_user] && socket.assigns.current_user.is_moderator,
      do: socket,
      else: handle_unauthorized(socket)
  end

  def handle_require_sign_in(socket) do
    socket
    |> put_flash(:error, "You must be logged in to view this page.")
    |> push_redirect(to: UserAuth.sign_in_path())
  end

  def handle_unauthorized(socket) do
    socket
    |> put_flash(:error, "You are not authorized to view this page.")
    |> push_redirect(to: "/")
  end
end

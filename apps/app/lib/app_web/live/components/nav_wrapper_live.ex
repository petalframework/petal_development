defmodule AppWeb.Components.NavWrapperLive do
  @moduledoc """
  Used to wrap <Nav> in a non-liveview. Used in the layout file app.html.eex
  """
  use AppWeb, :live_view

  def mount(_params, %{"active_page" => active_page} = session, socket) do
    socket =
      socket
      |> maybe_assign_current_user(session)
      |> assign(active_page: active_page)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <%= live_component @socket, Nav, [
        id: "navbar",
        current_user: @current_user,
        active_page: @active_page,
        max_width: "full"
      ] %>
    """
  end
end

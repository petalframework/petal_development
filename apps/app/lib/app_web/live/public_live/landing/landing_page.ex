defmodule AppWeb.PublicLive.LandingPage do
  use AppWeb, :surface_live_view
  alias AppWeb.PublicLive.LandingPage.Components.{Hero}

  data current_user, :any

  def mount(_params, session, socket) do
    {:ok, maybe_assign_current_user(socket, session)}
  end

  def render(assigns) do
    ~F"""
    <Nav id="nav" current_user={@current_user} active_page={:home} />
    <Hero current_user={@current_user} />
    """
  end
end

defmodule AppWeb.PrivateLive.PrivatePageExample do
  use AppWeb, :surface_live_view

  def mount(_, session, socket) do
    socket =
      socket
      |> require_current_user(session)

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, socket |> apply_action(socket.assigns.live_action, params)}
  end

  def apply_action(socket, :index, _params) do
    socket |> assign(page_title: "Private")
  end

  def render(assigns) do
    ~F"""
    <Nav id="navbar" active_page={:private_page_example} current_user={@current_user} />

    <Container class="pt-10">
      <Box>
        <div class="prose">
          <h1>Private Page</h1>
          <p>Only authenticated users can reach here</p>
        </div>
      </Box>
    </Container>
    """
  end
end

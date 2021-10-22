defmodule AppWeb.ModerateLive.Components.ModerateLayout do
  use AppWeb, :surface_component

  prop current_user, :any
  prop current_page, :atom
  data tabs, :list
  slot default

  def update(assigns, socket) do
    tabs = [
      %{
        label: "Users",
        path: Routes.moderate_users_path(socket, :index),
        is_active: assigns.current_page == :users
      },
      %{
        label: "Logs",
        path: Routes.moderate_logs_path(socket, :index),
        is_active: assigns.current_page == :logs
      }
    ]

    {:ok, assign(socket, Map.merge(assigns, %{tabs: tabs}))}
  end

  def render(assigns) do
    ~F"""
    <Nav id="nav" current_user={@current_user} active_page={:moderate} />

    <div class="shadow bg-secondary-900">
      <Container class="py-5">
        <nav class="flex">
          <LiveRedirect
            :for={tab <- @tabs}
            to={tab.path}
            label={tab.label}
            class={tab_class(tab.is_active)}
          />

          {#if Mix.env() == :dev}
            <Link to={Routes.email_testing_path(@socket, :index)} label="Emails" class={tab_class(false)} />

            <Link to="/dev/sent_emails" label="Sent emails" class={tab_class(false)} />
          {/if}
        </nav>
      </Container>
    </div>

    <#slot />
    """
  end

  def tab_class(false),
    do:
      "mr-2 px-3 py-2 text-sm font-medium leading-5 text-white rounded-md hover:text-primary-300"

  def tab_class(true),
    do:
      "mr-2 px-3 py-2 text-sm font-medium leading-5 text-white bg-primary-500 rounded-md focus:outline-none focus:bg-gray-300"
end

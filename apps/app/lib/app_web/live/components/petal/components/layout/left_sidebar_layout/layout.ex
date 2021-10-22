defmodule AppWeb.Petal.Components.LeftSidebarLayout.Layout do
  use AppWeb, :surface_component

  slot(sidebar)
  slot(default)

  @impl true
  def render(assigns) do
    ~F"""
    <div class="mt-5 lg:grid lg:grid-cols-12 lg:gap-x-5">
      <aside class="px-2 py-6 sm:px-6 lg:py-0 lg:px-0 lg:col-span-3">
        <div class="flex flex-col flex-grow mt-5">
          <nav class="flex-1 px-2 space-y-1" aria-label="Sidebar">
            <#slot name="sidebar" />
          </nav>
        </div>
      </aside>

      <div class="space-y-6 sm:px-6 lg:px-0 lg:col-span-9">
        <#slot />
      </div>
    </div>
    """
  end
end

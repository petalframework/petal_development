defmodule AppWeb.PublicLive.LandingPage.Components.Hero do
  use AppWeb, :surface_component

  prop current_user, :any, default: nil

  def render(assigns) do
    ~F"""
    <div class="">
      <div class="px-4 py-16 mx-auto max-w-7xl sm:px-6 lg:py-48 lg:px-8 lg:grid lg:grid-cols-3 lg:gap-x-8">
        <div>
          <h1 class="mt-3 h1 dark:text-white">Start building</h1>
          <p class="mt-4 text-lg text-gray-500">
            Go go go.
          </p>
        </div>
      </div>
    </div>
    """
  end
end

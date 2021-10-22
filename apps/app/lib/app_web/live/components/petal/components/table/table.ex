defmodule AppWeb.Petal.Components.Table do
  use AppWeb, :surface_component

  slot(default)

  @impl true
  def render(assigns) do
    ~F"""
    <div class="flex flex-col">
      <div class="-my-2 sm:-mx-6 lg:-mx-8">
        <div class="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
          <div class="border-b border-gray-200 shadow sm:rounded-lg">
            <table class="min-w-full divide-y divide-gray-200">
              <#slot />
            </table>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

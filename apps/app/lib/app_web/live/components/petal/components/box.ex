defmodule AppWeb.Petal.Components.Box do
  use AppWeb, :surface_component

  prop(class, :string)
  prop(title, :string)
  prop(remove_content_padding, :boolean, default: false)
  prop(hide_shadow, :boolean, default: false)
  prop(include_title_border, :boolean, default: false)
  slot(default)

  @impl true
  def render(assigns) do
    ~F"""
    <div class={@class, "bg-white dark:bg-gray-800 rounded-lg", shadow: !@hide_shadow, "px-4 py-5 sm:p-6": !@remove_content_padding}>
      <div :if={@title} class="mb-5 h3">
        {@title}
      </div>

      <#slot />
    </div>
    """
  end
end

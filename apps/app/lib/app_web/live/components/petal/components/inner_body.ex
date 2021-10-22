defmodule AppWeb.Petal.Components.InnerBody do
  use AppWeb, :surface_component

  prop class, :css_class
  prop dark, :boolean, default: false
  slot default

  def render(assigns) do
    ~F"""
    <div class={@class, "h-full w-full fixed overflow-y-scroll", "dark bg-gray-900": @dark}>
      <#slot />
    </div>
    """
  end
end

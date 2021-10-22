defmodule AppWeb.Petal.Components.LeftSidebarLayout.NavItem do
  use AppWeb, :surface_component

  prop(to, :string, required: true)
  prop(label, :string, required: true)
  prop(is_active, :boolean)
  prop(color_class, :string, default: "text-light-blue-600")
  slot(default, args: [:icon_class])

  @impl true
  def render(assigns) do
    ~F"""
    <LivePatch to={@to} class={menu_item_css(@color_class, @is_active)}>
      <#slot :args={icon_class: menu_icon_css(@color_class, @is_active)} />
      {@label}
    </LivePatch>
    """
  end

  def menu_item_css(color_class, active \\ false) do
    base = "flex items-center px-3 py-2 text-sm font-semibold rounded-md group "

    if active do
      base <>
        "dark:bg-gray-800 bg-white text-pink-600 hover:bg-white dark:hover:bg-gray-700 #{color_class}"
    else
      base <>
        "text-gray-600 dark:text-gray-600 hover:text-gray-800 dark:hover:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-800"
    end
  end

  def menu_icon_css(color_class, active \\ false) do
    base = "flex-shrink-0 w-6 h-6 mr-3 -ml-1 "

    if active do
      "#{base} #{color_class}"
    else
      base <>
        "text-gray-400 dark:text-gray-600 group-hover:text-gray-500"
    end
  end
end

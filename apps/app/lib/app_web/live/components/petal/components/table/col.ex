defmodule AppWeb.Petal.Components.Table.Col do
  use AppWeb, :surface_component

  prop(class, :css_class)
  slot(default)

  @impl true
  def render(assigns) do
    ~F"""
    <td class={"px-6 py-4 whitespace-nowrap text-sm text-gray-500", @class}>
      <#slot />
    </td>
    """
  end
end

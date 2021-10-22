defmodule AppWeb.Petal.Components.Table.Body do
  use AppWeb, :surface_component

  prop(rows, :list, required: true)

  @impl true
  def render(assigns) do
    ~F"""
    <tbody class="bg-white divide-y divide-gray-200">
      <tr :for={row <- @rows}>
        <td :for={col <- row} class="px-6 py-4 text-sm font-medium text-gray-900 whitespace-nowrap">
          {col}
        </td>
      </tr>
    </tbody>
    """
  end
end

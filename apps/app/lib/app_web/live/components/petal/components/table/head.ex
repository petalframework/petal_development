defmodule AppWeb.Petal.Components.Table.Head do
  use AppWeb, :surface_component

  prop(cols, :list, required: true)

  @impl true
  def render(assigns) do
    ~F"""
    <thead class="bg-gray-50">
      <tr>
        <th
          :for={col <- @cols}
          scope="col"
          class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase"
        >
          {col.label}
        </th>
      </tr>
    </thead>
    """
  end
end

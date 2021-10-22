defmodule AppWeb.Petal.Components.Star do
  use AppWeb, :surface_component

  prop(fill, :boolean, default: false)

  @impl true
  def render(assigns) do
    ~F"""
    <svg
      fill={"#{star_fill_color(@fill)}"}
      stroke="currentColor"
      stroke-linecap="round"
      stroke-linejoin="round"
      stroke-width="2"
      class="w-4 h-4 text-yellow-500"
      viewBox="0 0 24 24"
    >
      <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
    </svg>
    """
  end

  def star_fill_color(true) do
    "currentColor"
  end

  def star_fill_color(false) do
    "none"
  end
end

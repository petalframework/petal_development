defmodule AppWeb.Petal.Components.Pill do
  use AppWeb, :surface_component

  prop label, :string, required: true
  prop color, :string, default: "primary"
  prop rounded, :boolean, default: false
  prop class, :css_class

  @impl true
  def render(assigns) do
    ~F"""
    <span class={
      @class,
      get_color_css(@color),
      get_rounded_css(@rounded),
      "text-xs font-semibold inline-block py-1 px-2 uppercase uppercase last:mr-0 mr-1"
    }>
      {@label}
    </span>
    """
  end

  # We do this instead of just "text-#{color}-600" cause Tailwind wants the full class written out so the purge process knows not to purge it on prod build

  def get_color_css("primary"), do: "text-primary-600 bg-primary-200"
  def get_color_css("secondary"), do: "text-secondary-600 bg-secondary-200"
  def get_color_css("blue"), do: "text-blue-600 bg-blue-200"
  def get_color_css("red"), do: "text-red-600 bg-red-200"
  def get_color_css("green"), do: "text-green-600 bg-green-200"
  def get_color_css("yellow"), do: "text-yellow-600 bg-yellow-200"
  def get_color_css("orange"), do: "text-orange-600 bg-orange-200"
  def get_color_css("purple"), do: "text-purple-600 bg-purple-200"
  def get_color_css("gray"), do: "text-gray-600 bg-gray-200"
  def get_color_css("pink"), do: "text-pink-600 bg-pink-200"

  def get_rounded_css(true), do: "rounded-full"
  def get_rounded_css(false), do: "rounded"
end

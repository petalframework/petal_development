defmodule AppWeb.Petal.Components.Container do
  use AppWeb, :surface_component

  slot(default, required: true)
  prop(class, :string, default: "")

  prop(max_width, :string,
    values: [
      "prose",
      "sm",
      "md",
      "lg",
      "xl",
      "2xl",
      "full"
    ],
    default: "xl"
  )

  @impl true
  def render(assigns) do
    ~F"""
    <div class={max_width_class(@max_width), "mx-auto px-4 sm:px-6 lg:px-8", @class}>
      <#slot />
    </div>
    """
  end

  def max_width_class("prose"), do: "max-w-prose"
  def max_width_class("sm"), do: "max-w-screen-sm"
  def max_width_class("md"), do: "max-w-screen-md"
  def max_width_class("lg"), do: "max-w-screen-lg"
  def max_width_class("xl"), do: "max-w-screen-xl"
  def max_width_class("2xl"), do: "max-w-screen-2xl"
  def max_width_class("full"), do: ""
end

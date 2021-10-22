defmodule AppWeb.Petal.Components.PageHeading do
  use AppWeb, :surface_component

  prop(title, :string, required: true)
  prop(subtitle, :string)
  slot(left_content)
  slot(right_content)

  @impl true
  def render(assigns) do
    ~F"""
    <div class="md:flex md:items-center md:justify-between md:space-x-5">
      <div class="flex space-x-4">
        <#slot name="left_content" />

        <div class="">
          <div class="h2">{@title}</div>
          <div :if={@subtitle} class="subtitle">{@subtitle}</div>
        </div>
      </div>

      <#slot name="right_content" />
    </div>
    """
  end
end

defmodule AppWeb.Petal.Components.PageBanner do
  use AppWeb, :surface_component

  prop(title, :string, required: true)
  prop(subtitle, :string)
  prop(bg_class, :string, default: "bg-light-blue-600")
  prop(text_class, :string, default: "text-white")
  prop(container_max_width, :string, default: "md")
  slot(left_content)
  slot(right_content)

  @impl true
  def render(assigns) do
    ~F"""
    <div class={"py-6 md:py-10 shadow-md", @bg_class, @text_class}>
      <Container max_width={@container_max_width}>
        <PageHeading title={@title} subtitle={@subtitle}>
          <:left_content><#slot name="left_content" /></:left_content>
          <:right_content><#slot name="right_content" /></:right_content>
        </PageHeading>
      </Container>
    </div>
    """
  end
end

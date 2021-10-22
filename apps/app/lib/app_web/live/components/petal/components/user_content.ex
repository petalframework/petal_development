defmodule AppWeb.Petal.Components.UserContent do
  use AppWeb, :surface_component

  # For content inputted by users. Usually from textareas
  # TODO: allow markdown content

  prop(content, :string, required: true)
  prop(backup, :string)
  prop(class, :string, default: "")
  prop(is_markdown, :boolean, default: false)
  prop(truncate, :integer, default: 0)
  data(content_to_display, :string)

  def update(assigns, socket) do
    content_to_display =
      case assigns[:content] do
        nil -> assigns[:backup] || ""
        "" -> assigns[:backup] || ""
        text -> text
      end

    assigns = Map.put(assigns, :content_to_display, content_to_display)
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div
      class={"whitespace-pre-line #{@class}"}
      data-content={@content_to_display}
      {...%{
        "x-data" => "{ characters: #{@truncate}, string: ''}",
        "x-init" => "$nextTick(() => {string = #{if @truncate > 0,
          do: "truncate($el.dataset.content, characters) + ' (click to read more)'",
          else: "$el.dataset.content || '';"} })",
        "x-html" => "string",
        "@click" => "string = $el.dataset.content"
      }}
    />
    """
  end
end

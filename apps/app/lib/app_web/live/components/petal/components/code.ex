defmodule AppWeb.Petal.Components.Code do
  use AppWeb, :surface_component

  prop code, :string, required: true
  prop language, :string, default: "html"
  prop heading, :string
  prop right_text, :string

  def render(assigns) do
    ~F"""
    <div :if={assigns[:heading]} class="flex justify-between">
      <div class="mb-1 h4">
        {@heading}
      </div>

      <div :if={assigns[:right_text]} class="text-sm font-bold text-gray-500 italics">
        {@right_text}
      </div>
    </div>

    <div id={Util.random_string(10)} phx-hook="PrismHook">
      <pre><code class={"language-#{@language}"}>{HtmlEntities.decode(@code)}</code></pre>
    </div>
    """
  end
end

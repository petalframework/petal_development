defmodule AppWeb.Petal.Components.CodeHighlighter do
  @moduledoc """
  Will highlight any <pre> elements using Prism.js
  """
  use AppWeb, :surface_component

  slot default

  def render(assigns) do
    ~F"""
    <div phx-hook="PrismHook" id={Util.random_string()}>
      <#slot />
    </div>
    """
  end
end

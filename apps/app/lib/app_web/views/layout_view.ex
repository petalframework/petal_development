defmodule AppWeb.LayoutView do
  use AppWeb, :view

  @app_name "Petal"
  @default_description "SaaS boilerplate template powered by Elixir's Phoenix, TailwindCSS & Alpine JS"
  @default_keywords ["SaaS", "Elixir", "Phoenix", "TailwindCSS", "Boilerplate", "Template"]

  def app_name, do: @app_name

  def title(%{assigns: %{page_title: page_title}}), do: page_title
  def title(_conn), do: @app_name

  def description(%{assigns: %{meta_description: meta_description}}), do: meta_description
  def description(_conn), do: @default_description

  def keywords(%{assigns: %{meta_keywords: meta_keywords}}), do: Enum.join(meta_keywords, ", ")
  def keywords(_conn), do: Enum.join(@default_keywords, ", ")

  def notification_css(type) do
    case type do
      "success" -> "bg-green-600"
      "info" -> "bg-blue-600"
      "warning" -> "bg-yellow-600"
      "error" -> "bg-red-600"
    end
  end

  def progress_css(type) do
    case type do
      "success" -> "bg-green-800 opacity-100 "
      "info" -> "bg-blue-800 opacity-100 "
      "warning" -> "bg-yellow-800 opacity-100 "
      "error" -> "bg-red-800 opacity-100 "
    end
  end
end

defmodule AppWeb.Petal.Components.Spinner do
  use AppWeb, :surface_component

  prop size, :string, default: "sm", values: ["button", "sm", "md", "lg"]
  prop color_class, :css_class, default: ""
  prop show, :boolean, default: true

  @impl true
  def render(assigns) do
    ~F"""
    <svg
      :if={@show}
      class={"animate-spin -ml-1", @color_class, size_class(@size)}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
    >
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
      <path
        class="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
      />
    </svg>
    """
  end

  def size_class("button"), do: "-ml-0.5 mr-2 h-4 w-4"
  def size_class("sm"), do: "h-5 w-5"
  def size_class("md"), do: "h-8 w-8"
  def size_class("lg"), do: "h-16 w-16"
end

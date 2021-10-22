defmodule AppWeb.Petal.Components.Button do
  use AppWeb, :surface_component

  prop type, :string, values: ["submit", "button", "reset"]
  prop aria_label, :string
  prop size, :string, default: "md", values: ~w(xs sm md lg xl)
  prop label, :string
  prop disabled, :boolean, default: false

  prop color, :string,
    default: "primary",
    values:
      ~w(primary secondary green white gray gray-light blue pink purple orange red yellow-light deep-red)

  prop loading, :boolean, default: false
  prop click, :event
  prop phx_disable_with, :string
  prop class, :css_class
  prop opts, :list, default: []
  slot default

  @impl true
  def render(assigns) do
    ~F"""
    <button
      type={@type}
      aria-label={@aria_label}
      disabled={@disabled}
      :on-click={@click}
      class={@class, button_css(color: @color, size: @size), "cursor-not-allowed": @disabled}
      phx-disable-with={"#{@phx_disable_with}"}
      {...@opts}
    >
      <Spinner :if={@loading} size="button" />
      <span :if={@label}>{@label}</span>
      <#slot />
    </button>
    """
  end
end

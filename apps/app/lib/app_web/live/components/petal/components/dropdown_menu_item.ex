defmodule AppWeb.Petal.Components.DropdownMenuItem do
  use AppWeb, :surface_component

  @moduledoc """
  Represents one menu item. Use this within a <Dropdown> component

  <Dropdown label="Dropdown">
    <DropdownMenuItem type="Button" label="Option 1" />
    <DropdownMenuItem type="Button" label="Option 2" />
    <DropdownMenuItem type="Button" label="Option 3" />
  </Dropdown>
  """

  @doc "Label on the button"
  prop label, :string, required: true

  @doc "If it's a link, the path to which it points - (href)"
  prop to, :string

  @doc "Any options to pass to the underlying link or button"
  prop opts, :list, default: []

  @doc "The type of link or button"
  prop type, :string,
    default: "LiveRedirect",
    values: ["Link", "LiveRedirect", "LivePatch", "Button"]

  def render(%{type: "LiveRedirect"} = assigns) do
    ~F"""
    <LiveRedirect to={@to} class={class()} label={@label} opts={@opts} />
    """
  end

  def render(%{type: "Link"} = assigns) do
    ~F"""
    <Link to={@to} class={class()} label={@label} opts={@opts} />
    """
  end

  def render(%{type: "LivePatch"} = assigns) do
    ~F"""
    <LivePatch to={@to} class={class()} label={@label} opts={@opts} />
    """
  end

  def render(%{type: "Button"} = assigns) do
    ~F"""
    <button type="button" class={class()} {...@opts}>{@label}</button>
    """
  end

  def class(),
    do:
      "block px-4 py-2 text-sm text-gray-700 transition duration-150 ease-in-out hover:bg-gray-100 w-full text-left"
end

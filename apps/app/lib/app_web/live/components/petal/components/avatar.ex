defmodule AppWeb.Petal.Components.Avatar do
  use AppWeb, :surface_component

  prop class, :css_class
  prop src, :string
  prop cloudinary_id, :string
  prop height, :integer, default: 32
  prop initials, :string
  prop initials_background_color, :string

  @impl true
  def render(%{initials: _initials, cloudinary_id: nil, src: nil} = assigns) do
    ~F"""
    <span
      style={"width: #{@height}px; height: #{@height}px; font-size: #{@height / 3}px; background-color: #{@initials_background_color || generate_color_from_string(@initials)}"}
      class={"inline-flex items-center justify-center text-sm rounded-full shadow-lg", @class}
    >
      <span class="font-medium leading-none text-white">{@initials}</span>
    </span>
    """
  end

  @impl true
  def render(%{src: nil, cloudinary_id: cloudinary_id} = assigns) do
    ~F"""
    <CloudinaryImg
      cloudinary_id={cloudinary_id}
      transforms={%{
        height: @height,
        width: @height,
        crop: "fill",
        gravity: "face"
      }}
      class={"inline rounded-full", @class}
    />
    """
  end

  def render(%{src: src} = assigns) do
    ~F"""
      <img
        src={src}
        style={"width: #{@height}px; height: #{@height}px;"}
        class={"object-cover rounded-full", @class}
        loading="lazy"
      />
    """
  end

  def generate_color_from_string(string) do
    a_number =
      string
      |> String.to_charlist()
      |> Enum.reduce(0, fn x, acc -> x + acc end)

    "hsl(#{rem(a_number, 360)}, 69%, 49%)"
  end

  def generate_initials(name) do
    if !Util.blank?(name) do
      word_array = String.split(name)

      if length(word_array) == 1 do
        List.first(word_array)
        |> String.slice(0..1)
        |> String.upcase()
      else
        initial1 = String.first(List.first(word_array))
        initial2 = String.first(List.last(word_array))
        String.upcase(initial1 <> initial2)
      end
    end
  end
end

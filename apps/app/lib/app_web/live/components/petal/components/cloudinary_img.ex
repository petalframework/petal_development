defmodule AppWeb.Petal.Components.CloudinaryImg do
  use AppWeb, :surface_component

  prop(cloudinary_id, :string)
  prop(class, :css_class, default: "")
  prop(backup_src, :string)
  prop(transforms, :map, default: %{})

  @impl true
  def render(%{cloudinary_id: nil, backup_src: nil} = assigns) do
    ~F"""
    <span />
    """
  end

  @impl true
  def render(%{cloudinary_id: nil, backup_src: backup_src} = assigns) do
    ~F"""
    <img src={backup_src} class={@class} loading="lazy">
    """
  end

  @impl true
  def render(%{cloudinary_id: cloudinary_id} = assigns) do
    ~F"""
    <img src={Cloudex.Url.for(cloudinary_id, @transforms)} class={@class} loading="lazy">
    """
  end
end

# Transform options
# :aspect_ratio
# :border
# :color
# :coulor
# :crop (eg fill)
# :default_image
# :delay
# :density
# :dpr
# :effect
# :fetch_format
# :flags
# :gravity (eg south_east)
# :height
# :opacity
# :overlay
# :quality
# :radius
# :transformation
# :underlay
# :width
# :x
# :y
# :zoom

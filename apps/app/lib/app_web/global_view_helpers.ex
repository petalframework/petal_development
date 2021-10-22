defmodule AppWeb.GlobalViewHelpers do
  import Phoenix.HTML.Tag

  def avatar_url(%App.Accounts.User{avatar_cloudinary_id: avatar_cloudinary_id})
      when is_binary(avatar_cloudinary_id),
      do: cloudinary_url(avatar_cloudinary_id, %{width: 100, height: 100})

  def avatar_url(_), do: AppWeb.Endpoint.static_path("/images/default_avatar.png")

  @doc """
  Display public images from Cloudinary

  eg.
  cloudinary_url("a_public_id", %{width: 400, height: 300})
  cloudinary_url("a_public_id", %{crop: "fill", fetch_format: 'auto', flags: 'progressive', width: 300, height: 254, quality: "jpegmini", sign_url: true})
  cloudinary_url("a_public_id", [
    %{border: "5px_solid_rgb:c22c33", radius: 5, crop: "fill", height: 246, width: 470, quality: 80},
    %{overlay: "my_overlay", crop: "scale", gravity: "south_east", width: 128 ,x: 5, y: 15}
  ])
  """
  def cloudinary_url(public_id, transformation_options \\ %{}) do
    Cloudex.Url.for(public_id, transformation_options)
  end

  def cloudinary_img(public_id, options \\ [])

  def cloudinary_img(nil, _options) do
    ""
  end

  def cloudinary_img(public_id, options) do
    transformation_options =
      if Keyword.has_key?(options, :transforms) do
        Map.merge(%{}, options[:transforms])
      else
        %{}
      end

    image_tag_options = Keyword.delete(options, :transforms)

    defaults = [
      src: Cloudex.Url.for(public_id, transformation_options)
    ]

    attributes = Keyword.merge(defaults, image_tag_options)

    tag(:img, attributes)
  end

  def is_moderator?(nil), do: false

  def is_moderator?(user) do
    user.is_moderator
  end

  def avatar_props_for_user(user) do
    %{
      cloudinary_id: user.avatar_cloudinary_id,
      initials: AppWeb.Petal.Components.Avatar.generate_initials(user.name),
      initials_background_color:
        AppWeb.Petal.Components.Avatar.generate_color_from_string(user.email)
    }
  end
end

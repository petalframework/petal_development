defmodule Util.CloudinaryHelpers do
  def upload_widget_signature do
    # Signature generation for CloudinaryFileUploadHook
    # See: https://cloudinary.com/documentation/upload_images#generating_authentication_signatures
    cloudinary_timestamp = :os.system_time(:seconds)

    cloudinary_signature_string =
      "source=uw&timestamp=#{cloudinary_timestamp}&upload_preset=" <>
        System.get_env("CLOUDINARY_IMAGES_UPLOAD_PRESET") <>
        System.get_env("CLOUDINARY_SECRET")

    cloudinary_signature =
      :crypto.hash(:sha256, cloudinary_signature_string) |> Base.encode16() |> String.downcase()

    {cloudinary_timestamp, cloudinary_signature}
  end
end

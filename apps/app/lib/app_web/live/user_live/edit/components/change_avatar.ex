defmodule AppWeb.UserLive.Edit.Components.ChangeAvatar do
  use AppWeb, :surface_component

  prop profile_user, :map, required: true
  data cloudinary_timestamp, :string
  data cloudinary_signature, :string

  def update(assigns, socket) do
    {cloudinary_timestamp, cloudinary_signature} =
      Util.CloudinaryHelpers.upload_widget_signature()

    assigns =
      Map.merge(assigns, %{
        cloudinary_timestamp: cloudinary_timestamp,
        cloudinary_signature: cloudinary_signature
      })

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="flex items-center gap-5 pb-6">
      <div class="">
        <Avatar height={50} {...avatar_props_for_user(@profile_user)} />

        <div :if={@profile_user.avatar_cloudinary_id} class="relative inline-block">
          <button
            type="button"
            phx-click="delete_avatar"
            style="position: absolute; top: -10px; right: -12px"
          >
            <div class="w-5 h-5 bg-red-500 rounded-full hover:bg-red-600">
              <svg class="w-5 h-5 text-white" viewBox="0 0 20 20" fill="currentColor">
                <path
                  fill-rule="evenodd"
                  d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
          </button>
        </div>
      </div>

      <div :if={!@profile_user.avatar_cloudinary_id}>
        <button
          phx-hook="CloudinaryFileUploadHook"
          id="profilePictureUpload"
          type="button"
          data-file-formats="png,jpeg,webp"
          data-cloud-name={System.get_env("CLOUDINARY_CLOUD_NAME")}
          data-api-key={System.get_env("CLOUDINARY_API_KEY")}
          data-upload-preset={System.get_env("CLOUDINARY_IMAGES_UPLOAD_PRESET")}
          data-upload-signature-timestamp={@cloudinary_timestamp}
          data-upload-signature={@cloudinary_signature}
          data-field="avatar_cloudinary_id"
          class={button_css(size: "sm", color: "white")}
        >
          Upload a profile picture
        </button>

        <div class="inline-block text-xs text-gray-500">A real photo (optional). No logos</div>
      </div>
    </div>
    """
  end
end

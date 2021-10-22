defmodule AppWeb.Components.CloudinaryUploader do
  use AppWeb, :surface_component

  @moduledoc """
  Requires the hook 'CloudinaryFileUploadHook'
  Requires Cloudinary env vars CLOUDINARY_IMAGES_UPLOAD_PRESET & CLOUDINARY_CLOUD_NAME
  """

  prop(field, :string)
  prop(cloudinary_id, :string)
  prop(label, :string)
  prop(description, :string)

  @impl true
  def render(assigns) do
    ~F"""
    <div class="">
      <div class="flex justify-between py-5">
        <div>
          <div class={"#{label_css()}"}>{@label}</div>
          <div class="mb-2 text-sm text-gray-500">{@description}</div>
        </div>

        <div>
          <div :if={not is_nil(@cloudinary_id)} class="relative inline-block mt-3">
            <CloudinaryImg cloudinary_id={@cloudinary_id} class="w-20" transforms={width: 600} />

            <button
              :on-click="delete_file"
              phx-value-field={"#{@field}"}
              phx-value-cloudinary-id={"#{@cloudinary_id}"}
              style="position: absolute; top: -10px; right: -12px"
            >
              <svg class="w-5 h-5 text-red-500 hover:text-red-600" viewBox="0 0 20 20" fill="currentColor">
                <path
                  fill-rule="evenodd"
                  d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                  clip-rule="evenodd"
                />
              </svg>
            </button>
          </div>

          <button
            :if={is_nil(@cloudinary_id)}
            phx-hook="CloudinaryFileUploadHook"
            id={"#{@label}"}
            data-cloud-name={"#{System.get_env("CLOUDINARY_CLOUD_NAME")}"}
            data-upload-preset={"#{System.get_env("CLOUDINARY_IMAGES_UPLOAD_PRESET")}"}
            data-field={"#{@field}"}
            class={"#{button_css(color: "white")}"}
          >
            Upload image
          </button>
        </div>
      </div>
    </div>
    """
  end
end

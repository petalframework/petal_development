defmodule AppWeb.Petal.Components.Alert do
  use AppWeb, :surface_component

  prop type, :atom, required: true, values: [:success, :info, :warning, :error]
  prop heading, :string, required: true
  prop content, :string, required: true
  prop class, :css_class

  def render(assigns) do
    ~F"""
    <div class={"rounded-md p-4", get_bg_color(@type), @class}>
      <div class="flex">
        <div class="flex-shrink-0">
          <svg
            :if={@type == :success}
            class="w-6 h-6 text-green-400"
            x-description="Heroicon name: check-circle"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>

          <svg
            :if={@type == :info}
            class="w-6 h-6 text-blue-400"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
            />
          </svg>

          <svg
            :if={@type == :warning}
            class="w-6 h-6 text-yellow-400"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
            />
          </svg>

          <svg
            :if={@type == :error}
            class="w-6 h-6 text-red-400"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </div>
        <div class="ml-3 text-left">
          <h3 class={"text-sm font-semibold", get_heading_color(@type)}>
            {@heading}
          </h3>
          <div class={"mt-2 text-sm", get_text_color(@type)}>
            {@content}
          </div>
        </div>
      </div>
    </div>
    """
  end

  def get_bg_color(:success), do: "bg-green-100"
  def get_bg_color(:error), do: "bg-red-100"
  def get_bg_color(:warning), do: "bg-yellow-100"
  def get_bg_color(:info), do: "bg-blue-100"
  def get_bg_color(_), do: ""

  def get_heading_color(:success), do: "text-green-800"
  def get_heading_color(:error), do: "text-red-800"
  def get_heading_color(:warning), do: "text-yellow-800"
  def get_heading_color(:info), do: "text-blue-800"
  def get_heading_color(_), do: ""

  def get_text_color(:success), do: "text-green-700"
  def get_text_color(:error), do: "text-red-700"
  def get_text_color(:warning), do: "text-yellow-700"
  def get_text_color(:info), do: "text-blue-700"
  def get_text_color(_), do: ""
end

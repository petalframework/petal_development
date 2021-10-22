defmodule AppWeb.Petal.Components.ModalAlert do
  use AppWeb, :surface_component

  # A more direct version of a flash - when you want the message to definitely be seen.

  # Usage:
  # data(modal_alert, :any, default: nil)
  # <ModalAlert alert={{@modal_alert}} />
  # use ModalAlert
  # assign(socket, %{modal_alert: %{type: :error, title: "Title", content: "Content"}})

  prop(alert, :any)

  def render(%{alert: nil} = assigns) do
    ~F"""
    <span />
    """
  end

  def render(assigns) do
    ~F"""
    <div
      id="ModalAlert"
      class="fixed inset-0 z-10 overflow-y-auto"
      phx-hook="BodyScrollLockHook"
      phx-page-loading
    >
      <div class="flex items-end justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 transition-opacity">
          <div class="absolute inset-0 bg-gray-500 opacity-75" />
        </div>

        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">​</span>
        <div class="inline-block px-4 pt-5 pb-4 overflow-hidden text-left align-bottom transition-all transform bg-white rounded-lg shadow-xl sm:my-8 sm:align-middle sm:max-w-sm sm:w-full sm:p-6">
          <div>
            <div class={"flex items-center justify-center w-12 h-12 mx-auto rounded-full", get_bg_color(@alert[:type])}>
              <svg
                :if={@alert[:type] == :success}
                class="w-6 h-6 text-green-400"
                x-description="Heroicon name: check-circle"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>

              <svg
                :if={@alert[:type] == :info}
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
                :if={@alert[:type] == :warning}
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
                :if={@alert[:type] == :error}
                class="w-6 h-6 text-red-400"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </div>
            <div class="mt-3 text-center sm:mt-5">
              <h3 class="text-lg font-medium leading-6 text-gray-900" id="modal-headline">
                {@alert[:title]}
              </h3>
              <div class="mt-2">
                <UserContent class="text-sm text-gray-500" content={@alert[:content]} />
              </div>
            </div>
          </div>
          <div class="mt-5 sm:mt-6">
            <button
              :on-click="close_modal_alert"
              type="button"
              class="inline-flex justify-center w-full px-4 py-2 text-base font-medium text-white bg-indigo-600 border border-transparent rounded-md shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:text-sm"
            >
              {@alert[:close_button_text] || "Close"}
            </button>
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

  defmacro __using__(_) do
    quote do
      def handle_event("close_modal_alert", _, socket),
        do: {:noreply, assign(socket, %{modal_alert: nil})}
    end
  end
end

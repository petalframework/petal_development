defmodule AppWeb.Petal.Components.StripeElementsForm do
  use AppWeb, :surface_component

  prop(button_text, :string, default: "Pay now")

  @impl true
  def render(assigns) do
    ~F"""
    <form action="#" method="post">
      <div class="my-5 form-row">
        <label for="card-element" class={"#{label_css()}"}>
          Credit or debit card
        </label>
        <div id="card-element" class="mt-3 tag-input">
        </div>

        <div id="card-errors" class={error_tag_css(), "mt-3"} role="alert" />
      </div>

      <div class="mt-3 text-right">
        <button class="inline-flex items-center px-4 py-2 text-base font-medium leading-6 text-white transition duration-150 ease-in-out bg-green-600 border border-transparent rounded-md hover:bg-green-500 focus:border-green-700 active:bg-green-700">
          <svg
            class="hidden w-5 h-5 mr-3 -ml-1 text-white spinner animate-spin"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
          >
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
            <path
              class="opacity-75"
              fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
            />
          </svg>
          {@button_text}
        </button>
      </div>
    </form>

    <div
      :if={Mix.env() == :dev}
      class="absolute bottom-0 p-4 my-3 text-sm text-yellow-700 rounded-md bg-yellow-50"
    >
      Test card for development: 4000000360000006
    </div>
    """
  end
end

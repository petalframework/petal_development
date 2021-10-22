defmodule AppWeb.AuthLive.Password.Components.AuthLayout do
  use AppWeb, :surface_component

  prop nav_active_page, :atom, required: true
  prop heading, :string, required: true
  prop error_message, :any
  slot default, required: true
  slot subheading

  def render(assigns) do
    ~F"""
    <Nav id="nav" active_page={@nav_active_page} />

    <div class="flex flex-col justify-center py-12 mt-10 sm:px-6 lg:px-8">
      <div class="sm:mx-auto sm:w-full sm:max-w-md">
        <img
          class="w-auto h-12 mx-auto"
          src={"#{Routes.static_path(@socket, "/images/logo-icon.svg")}"}
          alt="Logo icon"
        />

        <div class="text-center h2 dark:text-white">
          {@heading}
        </div>

        <p class="mt-2 text-sm leading-5 text-center text-gray-700 dark:text-gray-400 max-w">
          <#slot name="subheading" />
        </p>
      </div>

      <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div class="px-4 py-8 bg-white shadow dark:bg-gray-800 sm:rounded-lg sm:px-10">
          <#slot />
          <Alert
            :if={@error_message}
            type={:error}
            heading="Error"
            class="mt-3"
            content={@error_message}
          />
        </div>
      </div>

      <div class="mt-10 text-center">
        <LiveRedirect
          to={Routes.public_landing_page_path(@socket, :index)}
          label="Cancel"
          class="text-sm text-gray-900 dark:text-gray-100 hover:underline"
        />
      </div>
    </div>
    """
  end
end

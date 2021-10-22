defmodule AppWeb.AuthLive.Passwordless.Components.SignIn do
  use AppWeb, :surface_component

  prop error_message, :string
  prop user_return_to, :string
  prop email, :string

  def render(assigns) do
    ~F"""
    <div class="flex flex-col justify-center py-12 mt-10 sm:px-6 lg:px-8">
      <div class="sm:mx-auto sm:w-full sm:max-w-md">
        <h2 class="mt-6 text-3xl font-extrabold leading-9 text-center text-gray-900 dark:text-white">
          Log in to your account
        </h2>
        <p class="mt-2 text-sm leading-5 text-center text-gray-600 max-w dark:text-gray-400">
          New to Petal?
          <LivePatch
            label="Register"
            to={Routes.auth_passwordless_path(@socket, :register, user_return_to: @user_return_to)}
            class={link_css()}
          />
        </p>
      </div>

      <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div class="px-4 py-8 bg-white shadow sm:rounded-lg sm:px-10 dark:bg-gray-800 ">
          <Form for={:user} opts={phx_submit: "submit_email"}>
            <FormField
              type="email"
              field={:email}
              value={@email}
              opts={placeholder: "name@email.com", autocomplete: "email"}
            />

            <div class="mt-0.5 mb-1 pt-2 ml-1 text-sm text-gray-500 text-center">
              <div class="inline-block w-64 text-center">Enter the email you signed up with and we'll send you a sign in code.</div>
            </div>

            <div
              :if={Util.present?(@error_message)}
              class="relative p-1 px-2 mt-4 text-sm text-yellow-800 bg-yellow-100 rounded"
              role="alert"
            >
              <span class="block sm:inline">{@error_message}</span>
            </div>

            <div class="mt-6">
              <Button
                color="primary"
                type="submit"
                class="w-full"
                label="Log in"
                phx_disable_with="Sending..."
              />
            </div>
          </Form>
        </div>
      </div>
    </div>
    """
  end
end

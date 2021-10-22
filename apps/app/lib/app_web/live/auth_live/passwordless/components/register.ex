defmodule AppWeb.AuthLive.Passwordless.Components.Register do
  use AppWeb, :surface_component

  prop registration_changeset, :any
  prop user_return_to, :string

  def render(assigns) do
    ~F"""
    <div class="flex flex-col justify-center py-12 mt-10 sm:px-6 lg:px-8">
      <div class="sm:mx-auto sm:w-full sm:max-w-md">
        <h2 class="mt-6 text-3xl font-extrabold leading-9 text-center text-gray-900 dark:text-white">
          Register
        </h2>

        <p class="mt-2 text-sm leading-5 text-center text-gray-600 dark:text-gray-400 max-w">
          Already have an account?
          <LivePatch
            label="Log in"
            to={Routes.auth_passwordless_path(@socket, :sign_in, user_return_to: @user_return_to)}
            class={link_css()}
          />
        </p>
      </div>

      <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div class="px-4 py-8 bg-white shadow dark:bg-gray-800 sm:rounded-lg sm:px-10">
          <Form for={@registration_changeset} as={:user} opts={phx_submit: :allow_submit_register}>
            <FormField
              type="text"
              label="Name"
              field={:name}
              debounce="500"
              opts={[placeholder: "eg. John Smith"]}
            />

            <FormField
              type="email"
              label="Email"
              field={:email}
              debounce="500"
              opts={placeholder: "jo@gmail.com", autocomplete: "email"}
            />

            <div class="mt-6">
              <Button
                color="primary"
                type="submit"
                class="w-full"
                label="Register"
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

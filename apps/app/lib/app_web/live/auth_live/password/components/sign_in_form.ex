defmodule AppWeb.AuthLive.Password.Components.SignInForm do
  use AppWeb, :surface_component

  def render(assigns) do
    ~F"""
    <Form for={:user} opts={phx_submit: "sign-in"}>
      <FormField type="text" opts={placeholder: "Enter your email"} label="Email" field={:email} />
      <FormField
        type="password"
        opts={placeholder: "Enter your password"}
        label="Password"
        field={:password}
      />

      <div class="flex items-center justify-between mt-6">
        <FormField type="checkbox" label="Remember me" field={:remember_me} />

        <div class="text-sm leading-5">
          <LiveRedirect
            to={Routes.auth_password_reset_password_path(@socket, :index)}
            label="Forgot your password?"
            class="font-medium text-blue-600 transition duration-150 ease-in-out dark:text-gray-400 dark:hover:text-gray-300 hover:text-blue-500 focus:outline-none focus:underline"
          />
        </div>
      </div>

      <Button class="w-full mt-5" phx_disable_with="Signing in...">
        Sign in
      </Button>
    </Form>
    """
  end
end

defmodule AppWeb.AuthLive.Password.ResetPassword do
  use AppWeb, :surface_live_view
  alias App.Accounts
  alias alias AppWeb.AuthLive.Password.Components.AuthLayout

  data submitted_email, :string

  def render(assigns) do
    ~F"""
    <AuthLayout nav_active_page={:reset_password} heading="Forgot your password?">
      <:subheading>
        Or
        <LiveRedirect
          to={UserAuth.sign_in_path()}
          label="go back to log in"
          class="font-medium transition duration-150 ease-in-out dark:text-secondary-500 text-secondary-600 dark:hover:text-secondary-400 hover:text-secondary-500 focus:outline-none focus:underline"
        />
      </:subheading>

      <Form :if={!assigns[:submitted_email]} for={:user} opts={phx_submit: "submit"}>
        <FormField type="text" label="Enter your email" field={:email} opts={phx_hook: "AutofocusHook"} />
        <Button class="w-full mt-5" label="Email reset instructions" phx_disable_with="Emailing..." />
      </Form>

      <div :if={assigns[:submitted_email]}>
        <Alert
          type={:success}
          heading="Submitted"
          content={"If '#{@submitted_email}' is in our system, you will receive instructions to reset your password shortly."}
        />

        <Button label="Start over" color="gray" size="sm" click="reset" class="mt-5" />
      </div>
    </AuthLayout>
    """
  end

  def handle_event("submit", %{"user" => %{"email" => email}}, socket) do
    email = Util.trim(email)

    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &Routes.auth_password_set_new_password_url(socket, :index, &1)
      )
    end

    {:noreply, assign(socket, %{submitted_email: email})}
  end

  def handle_event("reset", _, socket) do
    {:noreply, assign(socket, %{submitted_email: nil})}
  end
end

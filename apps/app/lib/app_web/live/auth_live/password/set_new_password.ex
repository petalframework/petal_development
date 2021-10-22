defmodule AppWeb.AuthLive.Password.SetNewPassword do
  use AppWeb, :surface_live_view
  alias App.Accounts
  alias alias AppWeb.AuthLive.Password.Components.AuthLayout

  data changeset, :any
  data user, :any

  def mount(%{"token" => token}, _session, socket) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      {:ok,
       assign(socket, %{
         user: user,
         changeset: Accounts.change_user_password(user)
       })}
    else
      socket =
        socket
        |> put_flash(:error, "Reset password link is invalid or it has expired.")
        |> push_redirect(to: "/")

      {:ok, socket}
    end
  end

  def render(assigns) do
    ~F"""
    <AuthLayout nav_active_page={:set_new_password} heading="Set a new password">
      <:subheading>
        Or
        <LiveRedirect
          to={UserAuth.sign_in_path()}
          label="go back to log in"
          class="font-medium transition duration-150 ease-in-out dark:text-secondary-500 text-secondary-600 dark:hover:text-secondary-400 hover:text-secondary-500 focus:outline-none focus:underline"
        />
      </:subheading>
      <Form for={@changeset} opts={phx_submit: "submit"}>
        <FormField
          type="password"
          field={:password}
          label="New password"
          opts={phx_hook: "AutofocusHook"}
        />

        <FormField type="password" field={:password_confirmation} label="New password confirmation" />
        <Button class="w-full mt-5" label="Set new password" phx_disable_with="Setting..." />
      </Form>
    </AuthLayout>
    """
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("submit", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Password reset successfully.")
          |> push_redirect(to: UserAuth.sign_in_path())

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> put_flash(
            :error,
            "Change password failed"
          )
          |> assign(changeset: changeset)

        {:noreply, socket}
    end
  end
end

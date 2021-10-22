defmodule AppWeb.AuthLive.Password.Components.SignInTokenForm do
  use AppWeb, :surface_component

  prop(sign_in_token, :string, required: true)
  prop(user_return_to, :string)

  def render(assigns) do
    ~F"""
    <div class="flex justify-center">
      <Form
        for={:user}
        action={Routes.user_session_path(@socket, :token_sign_in)}
        opts={phx_trigger_action: Util.present?(@sign_in_token)}
      >
        <Field name="sign_in_token">
          <HiddenInput value={@sign_in_token} />
        </Field>

        <Field name="user_return_to">
          <HiddenInput value={@user_return_to} />
        </Field>

        <Spinner size="lg" />
      </Form>
    </div>
    """
  end
end

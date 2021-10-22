defmodule AppWeb.UserLive.Edit.Components.ChangePassword do
  use AppWeb, :surface_component

  prop(changeset, :changeset, required: true)

  @impl true
  def render(assigns) do
    ~F"""
    <Box title="Change password">
      <Form
        for={@changeset}
        action={Routes.user_settings_path(@socket, :update_password)}
        as={:user}
        opts={autocomplete: "off"}
      >
        <FormField autofocus type="password" field={:current_password} label="Current password" />
        <FormField type="password" field={:password} label="New password" />
        <FormField type="password" field={:password_confirmation} label="New password confirmation" />
        <Button label="Update" />
      </Form>
    </Box>
    """
  end
end

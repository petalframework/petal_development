defmodule AppWeb.UserLive.Edit.Components.ChangeEmail do
  use AppWeb, :surface_component

  prop(changeset, :changeset, required: true)

  def render(assigns) do
    ~F"""
    <Box title="Change your email address">
      <Form for={@changeset} as={:user} opts={autocomplete: "off", phx_submit: "update-email"}>
        <FormField
          type="text"
          field={:email}
          help_text="Update this to your new email"
          label="New email"
          autofocus
        />

        <FormField label="Password" type="password" field={:current_password} />
        <Button phx_disable_with="Updating..." label="Update" />
      </Form>
    </Box>
    """
  end
end

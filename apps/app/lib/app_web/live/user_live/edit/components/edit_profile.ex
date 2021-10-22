defmodule AppWeb.UserLive.Edit.Components.EditProfile do
  use AppWeb, :surface_component
  alias AppWeb.UserLive.Edit.Components.ChangeAvatar

  prop changeset, :map, required: true
  prop user, :map, required: true

  def render(assigns) do
    ~F"""
    <Box >
      <Form for={@changeset} as={:user} opts={phx_submit: "submit"}>
        <ChangeAvatar profile_user={@user} />

        <FormField
          label="Name"
          type="text"
          field={:name}
          placeholder="eg. John Smith"
          autofocus
        />

        <div class="flex justify-end">
          <Button class="float-right" phx_disable_with="Updating..." label="Update profile" />
        </div>
      </Form>
    </Box>
    """
  end
end

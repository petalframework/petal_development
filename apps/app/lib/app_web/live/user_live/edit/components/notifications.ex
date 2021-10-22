defmodule AppWeb.UserLive.Edit.Components.Notifications do
  use AppWeb, :surface_component

  prop changeset, :map, required: true
  prop notification_fields, :list, required: true

  def render(assigns) do
    ~F"""
    <Box title="Notifications">
      <Form for={@changeset} as={:user} opts={phx_submit: "submit"}>
        <div :for={field <- @notification_fields} class="mb-5">
          <FormField
            type="checkbox"
            field={field.field}
            label={field.label}
            help_text={field.description}
            opts={[phx_update: "ignore"]}
          />
        </div>

        <div class="flex justify-end">
          <Button class="float-right" phx_disable_with="Updating..." label="Update notifications" />
        </div>
      </Form>
    </Box>
    """
  end
end

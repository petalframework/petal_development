defmodule AppWeb.AuthLive.Password.Components.UserDetailsForm do
  use AppWeb, :surface_component

  prop(changeset, :map, required: true)

  def render(assigns) do
    ~F"""
    <Form for={@changeset} opts={phx_submit: "register"}>
      <FormField field={:email} label="Email" opts={disabled: "true"} />

      <FormField
        label="Name"
        type="text"
        field={:name}
        placeholder="eg. John Smith"
        autofocus
      />

      <FormField type="password" label="Password" field={:password} />

      <div class="mt-3 text-right">
        <Button label="Register" phx_disable_with="Registering..." />
      </div>
    </Form>
    """
  end
end

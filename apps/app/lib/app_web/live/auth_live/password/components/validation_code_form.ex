defmodule AppWeb.AuthLive.Password.Components.ValidationCodeForm do
  use AppWeb, :surface_component

  prop(email_sent_to, :string, required: true)

  def render(assigns) do
    ~F"""
    <Form for={:user} opts={phx_submit: "submit_email_validation_code"}>
      <FormField
        field={:code}
        label={"Enter the code sent to #{@email_sent_to}"}
        autofocus
      />
      <div class="mt-3 text-right">
        <Button label="Re-enter email" color="gray" click="start_over" type="button" />
        <Button label="Submit code" phx_disable_with="Checking..." />
      </div>
    </Form>
    """
  end
end

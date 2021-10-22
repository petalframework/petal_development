defmodule AppWeb.AuthLive.Password.Components.EmailForm do
  use AppWeb, :surface_component

  def render(assigns) do
    ~F"""
    <Form for={:user} opts={phx_submit: "submit_email"}>
      <FormField
        field={:email}
        label="What is your email?"
        placeholder="Enter your email"
        autofocus
      />
      <div class="mt-3 text-right">
        <Button label="Submit" phx_disable_with="Submitting..." />
      </div>
    </Form>
    """
  end
end

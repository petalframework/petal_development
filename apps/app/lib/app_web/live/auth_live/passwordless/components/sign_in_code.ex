defmodule AppWeb.AuthLive.Passwordless.Components.SignInCode do
  use AppWeb, :surface_component

  prop submit_sign_in?, :boolean, default: false
  prop enable_resend?, :boolean, default: false
  prop error_message, :string
  prop user_return_to, :string
  prop email, :string
  prop base64_token, :string

  def render(assigns) do
    ~F"""
    <div
      id="PasswordlessSignInHook"
      phx-hook="PasswordlessSignInHook"
      class="flex flex-col justify-center py-12 mt-10 sm:px-6 lg:px-8"
    >
      <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div class="px-4 py-8 bg-white shadow dark:bg-gray-800 sm:rounded-lg sm:px-10 ">
          <div style="display: none;" class="flex items-center gap-3 loading">
            <Spinner color_class="text-primary-600 dark:text-primary-400" size="md" />
            <div class={heading_css("h2")}>Signing in...</div>
          </div>

          <Form
            for={:user}
            action={Routes.user_session_path(@socket, :token_sign_in)}
            opts={
              phx_submit: :trigger_sign_in,
              phx_change: :validate_pin,
              phx_trigger_action: @submit_sign_in?,
            }
          >
            <div class="pb-3">
              <div class={heading_css("h2"), "mb-2"}>
                Check your email
              </div>
              <p class="text-sm">
              </p>
            </div>

            <FormField
              :if={!@submit_sign_in?}
              type="number"
              label="Your sign in code"
              field={:pin}
              input_additional_class="font-mono md:text-2xl text-center sign_in_code"
              opts={[
                min: 0,
                max: 10_000_000,
                inputmode: "numeric",
                pattern: "[0-9]*",
                onKeyPress: "if(this.value.length==6) return false;",
                autofill: "off",
                autocomplete: "off",
                autofocus: true
              ]}
            />

            <div
              :if={Util.present?(@error_message)}
              class="relative p-1 px-2 mt-4 text-sm text-yellow-800 bg-yellow-100 rounded"
              role="alert"
            >
              <span class="block sm:inline">{@error_message}</span>
            </div>

            <div class="mt-0.5 mb-1 pt-2 ml-1 text-sm text-gray-500 text-center">
              <div class="inline-block w-64 text-center">
                We've sent a 6 digit sign in code to<br>
                <span class="font-semibold">{@email}</span>
                <br>Can't find it? Check your spam folder.
              </div>
            </div>

            <div class="mt-6">
              <input type="hidden" name="user[base64_token]" value={@base64_token}>
              <input type="hidden" name="user_return_to" value={@user_return_to}>

              <Button
                :if={@base64_token}
                color="primary"
                type="submit"
                class="w-full"
                label="Log in"
                phx_disable_with="Logging in..."
              />

              <Button
                :if={@enable_resend?}
                color="primary"
                type="button"
                class="w-full"
                label="Resend"
                phx_disable_with="Resending new pin..."
                opts={phx_click: "resend"}
              />
            </div>
          </Form>
        </div>
      </div>
    </div>
    """
  end
end

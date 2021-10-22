defmodule AppWeb.AuthLive.SignOut do
  use AppWeb, :surface_live_view

  # Log the user out via an intermediate page that then redirects to a GET via JS hook
  # This prevents any logged in pages performing remount() when the session is deleted before redirecting to /
  # See AppWeb.UserAuth.log_out_user to examine the order of operations when logging out.
  def render(assigns) do
    ~F"""
    <div
      id="AuthLogoutHook"
      phx-hook="AuthLogoutHook"
      class="flex flex-col justify-center py-12 sm:px-6 lg:px-8"
    >
      <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <Box class="flex items-center gap-3">
          <Spinner color_class="text-primary-600 dark:text-primary-400" size="md" />
          <div class={heading_css("h2")}>Signing out...</div>
        </Box>
      </div>
    </div>
    """
  end
end

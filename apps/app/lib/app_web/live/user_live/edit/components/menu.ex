defmodule AppWeb.UserLive.Edit.Components.Menu do
  use AppWeb, :surface_component
  alias LeftSidebarLayout.NavItem

  prop(live_action, :string, required: true)
  prop(profile_user, :map, required: true)

  def render(assigns) do
    ~F"""
    <nav class="space-y-1">
      <NavItem
        to={Routes.user_edit_path(@socket, :index, @profile_user)}
        is_active={@live_action == :index}
        label="Profile"
        :let={icon_class: icon_class}
      >
        <svg class={"#{icon_class}"} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
          />
        </svg>
      </NavItem>

      <NavItem
        to={Routes.user_edit_path(@socket, :change_email, @profile_user)}
        is_active={@live_action == :change_email}
        label="Change email"
        :let={icon_class: icon_class}
      >
        <svg class={"#{icon_class}"} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207" />
        </svg>
      </NavItem>

      <NavItem
        to={Routes.user_edit_path(@socket, :change_password, @profile_user)}
        is_active={@live_action == :change_password}
        label="Change password"
        :let={icon_class: icon_class}
      >
        <svg class={"#{icon_class}"} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
        </svg>
      </NavItem>

      <NavItem
        to={Routes.user_edit_path(@socket, :notifications, @profile_user)}
        is_active={@live_action == :notifications}
        label="Notifications"
        :let={icon_class: icon_class}
      >
        <svg class={"#{icon_class}"} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"
          />
        </svg>
      </NavItem>
    </nav>
    """
  end
end

defmodule AppWeb.Components.Nav do
  @moduledoc """
  Use this to wrap a <Navbar> and supply it with menu items based on whether there is a logged in user and their role.
  """
  use AppWeb, :surface_live_component

  prop active_page, :atom, default: :home
  prop current_user, :any
  prop max_width, :string, default: "full"
  data top_menu_links, :list, default: []
  data user_menu_links, :list, default: []

  def update(assigns, socket) do
    assigns =
      assigns
      |> Map.put(:top_menu_links, top_menu_links(assigns[:current_user]))
      |> Map.put(:user_menu_links, user_menu_links(assigns[:current_user]))

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~F"""
    <Navbar
      current_user={@current_user}
      active_page={@active_page}
      top_menu_links={@top_menu_links}
      user_menu_links={@user_menu_links}
      max_width={@max_width}
    />
    """
  end

  # Logged out
  def user_menu_links(nil), do: []

  # Logged in
  def user_menu_links(current_user) do
    [get_link(:settings, current_user)]
    |> maybe_add_moderator_links(current_user)
    |> (fn links ->
          links ++
            [
              get_link(:sign_out)
            ]
        end).()
  end

  # Logged out
  def top_menu_links(nil),
    do: [
      get_link(:sign_in),
      get_link(:register),
      get_link(:private_page)
    ]

  # Logged in
  def top_menu_links(_user) do
    [get_link(:private_page)]
  end

  defp maybe_add_moderator_links(links, %{is_moderator: false}), do: links

  defp maybe_add_moderator_links(links, %{is_moderator: true} = current_user) do
    links ++
      [
        get_link(:moderate_users, current_user)
      ]
  end

  def get_link(name, current_user \\ nil)

  def get_link(:register, _current_user) do
    %{
      name: :register,
      label: "Register",
      path: UserAuth.register_path()
    }
  end

  def get_link(:sign_in, _current_user) do
    %{
      name: :sign_in,
      label: "Sign in",
      path: UserAuth.sign_in_path()
    }
  end

  def get_link(:sign_out, _current_user) do
    %{
      name: :sign_out,
      label: "Sign out",
      path: Routes.live_path(AppWeb.Endpoint, AppWeb.AuthLive.SignOut)
    }
  end

  def get_link(:settings, current_user) do
    %{
      name: :settings,
      label: "Settings",
      path: Routes.user_edit_path(AppWeb.Endpoint, :index, current_user)
    }
  end

  def get_link(:private_page, _current_user) do
    %{
      name: :private_page,
      label: "Private Page",
      path: Routes.private_private_page_example_path(AppWeb.Endpoint, :index)
    }
  end

  # Moderator
  def get_link(:moderate_users = name, _current_user) do
    %{
      name: name,
      label: "Moderate",
      path: Routes.moderate_users_path(AppWeb.Endpoint, :index)
    }
  end

  def get_link(:email_templates, _current_user) do
    %{
      name: :email_templates,
      label: "🛠️ Email templates",
      path: "/dev/emails"
    }
  end

  def get_link(:sent_emails, _current_user) do
    %{
      name: :sent_emails,
      label: "🛠️ Sent emails",
      path: "/dev/sent_emails"
    }
  end
end

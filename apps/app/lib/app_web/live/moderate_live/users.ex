defmodule AppWeb.ModerateLive.Users do
  use AppWeb, :surface_live_view
  alias App.Repo
  alias App.Accounts.UserQuery
  alias AppWeb.ModerateLive.Components.ModerateLayout

  data page_title, :string
  data load_more, :boolean
  data text_search, :string
  data limit, :number
  data users, :list, default: []

  def mount(_params, session, socket) do
    socket =
      socket
      |> require_moderator(session)
      |> assign(%{
        page_title: "Moderate users",
        load_more: false,
        text_search: "",
        limit: 25
      })

    {:ok, set_users(socket)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~F"""
    <ModerateLayout current_user={@current_user} current_page={:users}>
      <div class="pt-10 pb-8">
        <Container>
          <div class="mb-5 h2">
            All users ({length(@users)})
          </div>

          <div class="mb-5">
            <form phx-change="search" phx-submit="search">
              <input
                class={input_css()}
                type="text"
                name="text_search"
                value={@text_search}
                placeholder="Search"
                phx-debounce="1000"
                autocomplete="off"
                autofocus
              />
            </form>
          </div>

          <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
            <div class="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
              <div class="overflow-hidden border-b border-gray-200 shadow sm:rounded-lg">
                <table class="min-w-full divide-y divide-gray-200">
                  <thead>
                    <tr>
                      <th class={th_class()}>
                        Name
                      </th>
                      <th class={th_class()}>
                        Email
                      </th>
                      <th class={th_class()}>
                        Role
                      </th>
                      <th class={th_class()}>
                        Suspended
                      </th>
                      <th class="px-6 py-3 bg-gray-50" />
                    </tr>
                  </thead>

                  <tbody class="bg-white divide-y divide-gray-200">
                    <tr :for={user <- @users}>
                      <td class={td_class()}>
                        <Avatar {...avatar_props_for_user(user)} />

                        <LiveRedirect
                          to={Routes.user_edit_path(@socket, :index, user)}
                          label={user.name}
                          class="ml-2 font-semibold hover:text-royalblue-600 hover:underline"
                        />
                      </td>
                      <td class={td_class()}>
                        {user.email}
                      </td>
                      <td class={td_class()}>
                        {if user.is_moderator, do: "Moderator", else: "User"}
                      </td>
                      <td class={td_class()}>
                        {if user.is_suspended, do: "Yes", else: "No"}
                      </td>
                      <td class="px-6 py-4 text-sm font-medium leading-5 text-right whitespace-nowrap">
                        <LiveRedirect
                          to={Routes.moderate_logs_path(@socket, :index, %{user_id: user.id})}
                          label="Logs"
                          class="ml-2 font-semibold hover:text-royalblue-600 hover:underline"
                        />
                        <LiveRedirect
                          to={Routes.user_edit_path(@socket, :index, user)}
                          label="Edit"
                          class="ml-2 font-semibold hover:text-royalblue-600 hover:underline"
                        />
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <div :if={@load_more} class="w-2/4 mx-auto mt-5">
              <Button click="load-more" class="w-full">
                <span class="hide-if-loading">Show More</span>
                <span class="show-if-loading">
                  <Spinner size="button" />
                </span>
              </Button>
            </div>
          </div>
        </Container>
      </div>
    </ModerateLayout>
    """
  end

  def handle_event("search", %{"text_search" => text_search}, socket) do
    socket = assign(socket, %{text_search: text_search})
    {:noreply, set_users(socket)}
  end

  def handle_event("load-more", _, socket) do
    socket =
      socket
      |> update(:limit, fn limit -> limit + 25 end)
      |> set_users()

    {:noreply, socket}
  end

  def set_users(socket) do
    users =
      UserQuery.not_deleted()
      |> UserQuery.text_search(socket.assigns.text_search || "")
      |> UserQuery.limit(socket.assigns.limit || 25)
      |> UserQuery.order_by(:newest)
      |> Repo.all()

    assign(socket, %{users: users, load_more: length(users) >= socket.assigns.limit})
  end
end

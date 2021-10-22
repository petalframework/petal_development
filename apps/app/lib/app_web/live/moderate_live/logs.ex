defmodule AppWeb.ModerateLive.Logs do
  use AppWeb, :surface_live_view
  alias App.{Repo, Accounts}
  alias App.Logs.{LogQuery}
  alias AppWeb.ModerateLive.LogsSearchChangeset
  alias AppWeb.ModerateLive.Components.ModerateLayout

  data load_more, :boolean, default: false
  data action, :string
  data limit, :integer
  data search_changeset, :any

  def mount(_params, session, socket) do
    if connected?(socket) do
      AppWeb.Endpoint.subscribe("logs")
    end

    socket =
      socket
      |> require_moderator(session)
      |> assign(%{
        page_title: "Logs",
        load_more: false,
        action: "",
        limit: 20,
        search_changeset: LogsSearchChangeset.build(%{})
      })

    {:ok, set_logs(socket)}
  end

  def handle_params(params, uri, socket) do
    socket =
      socket
      |> assign(%{
        path: URI.parse(uri).path,
        search_changeset: LogsSearchChangeset.build(params)
      })
      |> set_logs()

    {:noreply, socket}
  end

  def render(assigns) do
    ~F"""
    <div class="flex flex-col h-screen bg-gray-100 dark:bg-gray-900">
      <ModerateLayout current_user={@current_user} current_page={:logs}>
        <div class="pt-10 pb-8">
          <Container>
            <h1 class="mb-5 h2">
              Activity
            </h1>
            <div class="mb-5">
              <Form for={@search_changeset} as={:search} change="search" submit="search">
                <div class="flex gap-x-5">
                  <div class="w-1/2 lg:w-1/4">
                    <FormField
                      type="select"
                      label="Filter"
                      field={:action}
                      select_options={App.Logs.Log.action_options() |> Enum.sort()}
                      opts={prompt: "Select an activity type..."}
                    />
                  </div>

                  <div class="flex w-1/2 lg:w-3/4 gap-x-3">
                    <div class="w-full lg:w-1/3">
                      <FormField
                        type="text"
                        label="User ID"
                        field={:user_id}
                        debounce="blue"
                        autocomplete={false}
                      />
                    </div>
                  </div>
                </div>

                <FormField type="checkbox" label="Live logs" field={:enable_live_logs} />
              </Form>
            </div>

            <div :if={length(Map.keys(@search_changeset.changes)) > 0} class="mb-2">
              <LivePatch
                label="Reset filters"
                to={Routes.moderate_logs_path(@socket, :index)}
                class="text-xs text-red-500 hover:underline"
              />
            </div>

            <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
              <div class="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
                <div class="overflow-hidden border-b border-gray-200 shadow sm:rounded-lg">
                  <table class="min-w-full divide-y divide-gray-200">
                    <thead>
                      <tr>
                        <th class={th_class()}>
                          Time
                        </th>
                        <th class={th_class()}>
                          User
                        </th>
                        <th class={th_class()}>
                          Action
                        </th>
                        <th class={th_class()}>
                          Details
                        </th>
                      </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                      <tr :for={log <- @logs}>
                        <td class={td_class()}>
                          <span
                            id={"log_#{log.id}"}
                            data-unix={Timex.to_unix(log.inserted_at)}
                            phx-hook="CurrentTimeHook"
                            class=""
                            data-tippy-content={Util.format_time(log.inserted_at)}
                          />
                        </td>
                        <td class={td_class()}>
                          {#if log.user}
                            <Avatar class="mr-2" {...avatar_props_for_user(log.user)} />
                            <LivePatch
                              label={log.user.name}
                              to={Routes.moderate_logs_path(
                                @socket,
                                :index,
                                Map.put(@search_changeset.changes, :user_id, log.user.id)
                              )}
                              class="font-medium hover:underline"
                            />
                            <LiveRedirect
                              to={Routes.user_edit_path(@socket, :index, log.user)}
                              class="inline-block w-4 h-4 -mt-1 text-gray-400 hover:text-royalblue-600"
                            >
                              <svg
                                xmlns="http://www.w3.org/2000/svg"
                                class="w-3 h-3"
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke="currentColor"
                              >
                                <path
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  stroke-width="2"
                                  d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                                />
                              </svg>
                            </LiveRedirect>
                          {#else}
                            User fully deleted
                          {/if}
                        </td>
                        <td class={td_class()}>
                          <LivePatch
                            label={log.action}
                            to={Routes.moderate_logs_path(
                              @socket,
                              :index,
                              Map.put(@search_changeset.changes, :action, log.action)
                            )}
                            class="font-medium hover:underline"
                          />
                          {maybe_add_emoji(log.action)}
                          <span :if={log.user_type == "moderator"}>
                            (as a mod)
                          </span>
                        </td>
                        <td class={td_class()}>
                          {#if Ecto.assoc_loaded?(log.target_user) && log.target_user}
                            <LivePatch
                              label={Util.truncate(log.target_user.name, length: 30)}
                              to={Routes.moderate_logs_path(
                                @socket,
                                :index,
                                Map.put(@search_changeset.changes, :user_id, log.target_user.id)
                              )}
                              class="font-medium hover:underline"
                            />
                            <LiveRedirect
                              to={Routes.user_edit_path(@socket, :index, log.target_user)}
                              class="inline-block w-4 h-4 -mt-1 text-gray-400 hover:text-royalblue-600"
                            >
                              <svg
                                xmlns="http://www.w3.org/2000/svg"
                                class="w-3 h-3"
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke="currentColor"
                              >
                                <path
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  stroke-width="2"
                                  d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                                />
                              </svg>
                            </LiveRedirect>
                          {/if}

                          {#if log.action in ["quick_register", "register", "sign_in"]}
                            <span class="text-sm">
                              {Util.truncate(log.user.email, length: 30)}
                              {#if log.user.confirmed_at == nil}
                                (not verified)
                              {/if}
                            </span>
                          {/if}

                          {#if log.action in ["pin_code_sent", "pin_code_too_many_incorrect_attempts"]}
                            <span class="text-sm">
                              {Util.truncate(log.user.email, length: 30)}

                              {#if log.user.confirmed_at == nil}
                                (not verified)
                              {/if}
                            </span>
                          {/if}
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>

              <div :if={@load_more} class="w-2/4 mx-auto mt-5">
                <button phx-click="load-more" class={button_css(), "w-full"}>
                  <span class="hide-if-loading">Show More</span>
                  <span class="show-if-loading">
                    <Spinner />
                  </span>
                </button>
              </div>
            </div>
          </Container>
        </div>
      </ModerateLayout>
    </div>
    """
  end

  def handle_event("search", %{"search" => search_params}, socket) do
    {:noreply, push_patch(socket, to: Routes.moderate_logs_path(socket, :index, search_params))}
  end

  def handle_event("load-more", _, socket) do
    socket =
      socket
      |> update(:limit, fn limit -> limit + 10 end)
      |> set_logs()

    {:noreply, socket}
  end

  def handle_info(
        %{
          topic: "logs",
          event: "new-log",
          payload: _log_attrs
        },
        socket
      ) do
    if socket.assigns.search_changeset.changes[:enable_live_logs] do
      {:noreply, set_logs(socket)}
    else
      {:noreply, socket}
    end
  end

  def set_logs(socket) do
    case LogsSearchChangeset.validate(socket.assigns.search_changeset) do
      {:ok, search} ->
        query =
          LogQuery.by_action(search[:action])
          |> LogQuery.limit(socket.assigns.limit)
          |> LogQuery.order_by(:newest)
          |> LogQuery.preload([
            :user,
            :target_user
          ])

        query =
          if search[:user_id] do
            user = Accounts.get_user!(search.user_id)
            LogQuery.by_user(query, user.id)
          else
            query
          end

        logs = Repo.all(query)

        assign(socket, %{logs: logs, load_more: length(logs) >= socket.assigns.limit})

      {:error, changeset} ->
        assign(socket, %{
          search_changeset: changeset,
          logs: []
        })
    end
  end

  defp maybe_add_emoji("register"), do: "🥳"
  defp maybe_add_emoji("sign_in"), do: "🙌"
  defp maybe_add_emoji("delete_user"), do: "❌"
  defp maybe_add_emoji(_), do: ""
end

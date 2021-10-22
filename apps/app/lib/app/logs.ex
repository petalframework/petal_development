defmodule App.Logs do
  import Ecto.Query, warn: false
  alias App.Repo
  alias App.Logs.Log
  require Logger

  def create(attrs \\ %{}) do
    %Log{}
    |> Log.changeset(attrs)
    |> Repo.insert()
  end

  def create_and_broadcast(log_params) do
    case create(log_params) do
      {:ok, _log} ->
        AppWeb.Endpoint.broadcast("logs", "new-log", log_params)

      {:error, cs} ->
        Logger.error("Log creation failed")
        IO.inspect(cs)
    end
  end

  def log_sync(action, params, throttle_seconds \\ 0) do
    log_params = log(action, params)

    if throttle_seconds > 0 do
      case DB.where(Log, Map.drop(log_params, [:metadata]))
           |> DB.order_by(id: :desc)
           |> DB.limit(1)
           |> Repo.one() do
        nil ->
          create_and_broadcast(log_params)

        last_log ->
          seconds_from_last_entry = Timex.diff(Timex.now(), last_log.inserted_at, :seconds)

          if seconds_from_last_entry > throttle_seconds do
            create_and_broadcast(log_params)
          end
      end
    else
      create_and_broadcast(log_params)
    end
  end

  def log_async(action, params, throttle_seconds \\ 0) do
    App.BackgroundTask.run(fn ->
      log_sync(action, params, throttle_seconds)
    end)
  end

  # Catch all, for simple actions
  def log(action, params) do
    target_user_id = if params[:target_user], do: params[:target_user].id, else: params.user.id

    %{
      user_id: params.user.id,
      target_user_id: target_user_id,
      action: action,
      user_role: if(params.user.is_moderator, do: "moderator", else: "user"),
      metadata: params[:metadata] || %{}
    }
  end

  def exists?(params) do
    Log
    |> QueryBuilder.where(params)
    |> App.Repo.exists?()
  end

  def get_last_log_of_user(user) do
    App.Logs.LogQuery.by_user(user.id)
    |> App.Logs.LogQuery.order_by(:newest)
    |> DB.limit(1)
    |> App.Repo.one()
  end
end

defmodule App.BackgroundTask do
  @doc """
  Run a function in a separate process parallel to the current one. Useful for things that take a bit of time but you want to send a response back quickly

  App.BackgroundTask.run(fn ->
    do_some_time_instensive_stuff()
  end)

  """
  def run(f) do
    Task.Supervisor.start_child(__MODULE__, f, restart: :transient)
  end
end

alias GangsServer.Messaging

defmodule Messaging.Pipeline do
  use GenServer

  @handler_pipeline [
    Messaging.Handler.Log,
    Messaging.Handler.Auth,
    Messaging.Handler.World,
  ]

  def handle_cast({:handle, :connect, conn_pid}, _) do
    conn_state = run_pipeline(:connect, %{conn_pid: conn_pid})
    Messaging.ConnectionStateLookup.put(conn_pid, conn_state)
    {:noreply, nil}
  end

  def handle_cast({:handle, :disconnect, conn_pid}, _) do
    conn_state = Messaging.ConnectionStateLookup.lookup(conn_pid)
    run_pipeline(:disconnect, conn_state)
    Messaging.ConnectionStateLookup.drop(conn_pid)
    {:noreply, nil}
  end

  def handle_cast({:handle, event, conn_pid}, _) do
    conn_state = Messaging.ConnectionStateLookup.lookup(conn_pid)
    conn_state = run_pipeline(event, conn_state)
    Messaging.ConnectionStateLookup.put(conn_pid, conn_state)
    {:noreply, nil}
  end

  defp run_pipeline(event, conn_state) do
    @handler_pipeline
    |> Enum.reduce_while(conn_state, fn handler, state ->
      handler.handle(event, state)
    end)
  end

  def start_link(opts \\ []), do: GenServer.start_link(__MODULE__, :ok, opts)
  def handle(event, conn_pid), do: GenServer.cast(__MODULE__, {:handle, event, conn_pid})
end

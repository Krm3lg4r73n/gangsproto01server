alias GangsServer.Messaging

defmodule Messaging.Pipeline do
  use GenServer

  @handler_pipeline [
    Messaging.Handler.Log,
    Messaging.Handler.Login,
    Messaging.Handler.World,
  ]

  def handle_cast({:handle, :connect, conn_pid}, _) do
    Messaging.ConnectionState.put(conn_pid, :conn_pid, conn_pid)
    conn_state = Messaging.ConnectionState.lookup(conn_pid)
    run_pipeline(:connect, conn_state)
    {:noreply, nil}
  end

  def handle_cast({:handle, :disconnect, conn_pid}, _) do
    conn_state = Messaging.ConnectionState.lookup(conn_pid)
    run_pipeline(:disconnect, conn_state)
    Messaging.ConnectionState.drop(conn_pid)
    {:noreply, nil}
  end

  def handle_cast({:handle, event, conn_pid}, _) do
    conn_state = Messaging.ConnectionState.lookup(conn_pid)
    run_pipeline(event, conn_state)
    {:noreply, nil}
  end

  defp run_pipeline(event, conn_state) do
    @handler_pipeline
    |> Enum.reduce_while(nil, fn handler, _ ->
      case handler.handle(event, conn_state) do
        :cont -> {:cont, nil}
        :halt -> {:halt, nil}
      end
    end)
  end

  def start_link(opts \\ []), do: GenServer.start_link(__MODULE__, :ok, opts)
  def handle(event, conn_pid), do: GenServer.cast(__MODULE__, {:handle, event, conn_pid})
end

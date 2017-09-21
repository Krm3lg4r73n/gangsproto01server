alias GangsServer.Messaging

defmodule Messaging.ConnectionState do
  use GenServer

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:put, conn_pid, key, value}, _from, table) do
    case Map.fetch(table, conn_pid) do
      {:ok, state} -> {:reply, :ok,
        Map.put(table, conn_pid, Map.put(state, key, value))}
      :error -> {:reply, :ok,
        Map.put(table, conn_pid, %{key => value})}
    end
  end

  def handle_call({:drop, conn_pid}, _from, table) do
    {:reply, :ok, Map.drop(table, [conn_pid])}
  end

  def handle_call({:lookup, conn_pid}, _from, table) do
    {:reply, Map.get(table, conn_pid), table}
  end

  # ==============

  def start_link(opts \\ []), do: GenServer.start_link(__MODULE__, :ok, opts)
  def put(conn_pid, key, value), do: GenServer.call(__MODULE__, {:put, conn_pid, key, value})
  def drop(conn_pid), do: GenServer.call(__MODULE__, {:drop, conn_pid})
  def lookup(conn_pid), do: GenServer.call(__MODULE__, {:lookup, conn_pid})
end

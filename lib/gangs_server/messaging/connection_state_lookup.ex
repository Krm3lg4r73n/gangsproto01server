alias GangsServer.Messaging

defmodule Messaging.ConnectionStateLookup do
  use GenServer

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:put, conn_pid, state}, _from, table) do
    {:reply, :ok, Map.put(table, conn_pid, state)}
  end

  def handle_call({:drop, conn_pid}, _from, table) do
    {:reply, :ok, Map.drop(table, [conn_pid])}
  end

  def handle_call({:lookup, conn_pid}, _from, table) do
    {:reply, Map.get(table, conn_pid), table}
  end

  # ==============

  def start_link(opts \\ []), do: GenServer.start_link(__MODULE__, :ok, opts)
  def put(conn_pid, state), do: GenServer.call(__MODULE__, {:put, conn_pid, state})
  def drop(conn_pid), do: GenServer.call(__MODULE__, {:drop, conn_pid})
  def lookup(conn_pid), do: GenServer.call(__MODULE__, {:lookup, conn_pid})

  # TODO: possibly implement as agent
  # def start_link(opts \\ []), do: Agent.start_link(__MODULE__, fn -> Map.new() end, opts)
  # def put(conn_pid, state), do: Agent.update(__MODULE__, &Map.put(&1, conn_pid, state))
  # def drop(conn_pid), do: Agent.update(__MODULE__, &Map.drop(&1, [conn_pid]))
  # def lookup(conn_pid), do: Agent.get(__MODULE__, &Map.get(&1, conn_pid))
end

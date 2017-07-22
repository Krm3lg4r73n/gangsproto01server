require Logger
alias GangsServer.TCP

defmodule TCP.ConnectionMonitor do
  use GenServer

  def init(:ok) do
    refs = MapSet.new
    {:ok, refs}
  end

  def handle_call({:monitor, connection}, _from, refs) do
    ref = Process.monitor(connection)
    refs = MapSet.put(refs, ref)
    TCP.EventManager.fire_connected(connection)
    {:reply, :ok, refs}
  end

  def handle_info({:DOWN, ref, :process, connection, _reason}, refs) do
    true = MapSet.member?(refs, ref)
    refs = MapSet.delete(refs, ref)
    TCP.EventManager.fire_disconnected(connection)
    {:noreply, refs}
  end

  #==============

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def monitor(connection) do
    GenServer.call(__MODULE__, {:monitor, connection})
  end
end

require Logger
alias GangsServer.TCP

defmodule TCP.ConnectionMonitor do
  use GenServer

  def init(:ok) do
    refs = MapSet.new
    {:ok, refs}
  end

  def handle_call({:monitor, conn}, _from, refs) do
    ref = Process.monitor(conn)
    refs = MapSet.put(refs, ref)
    TCP.EventManager.fire_connected(conn)
    {:reply, :ok, refs}
  end

  def handle_info({:DOWN, ref, :process, conn, _reason}, refs) do
    true = MapSet.member?(refs, ref)
    refs = MapSet.delete(refs, ref)
    TCP.EventManager.fire_disconnected(conn)
    {:noreply, refs}
  end

  #==============

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def monitor(conn) do
    GenServer.call(__MODULE__, {:monitor, conn})
  end
end

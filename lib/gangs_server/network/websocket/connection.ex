require Logger
alias GangsServer.Network

defmodule Network.Websocket.Connection do
  use GenServer

  ### GenServer API

  def init(client) do
    Socket.Web.accept!(client)
    listen(client)
    {:ok, client}
  end

  def listen(client) do
    me = self()
    {:ok, fn -> init(client, me) end |> spawn_link}
  end

  defp init(%{socket: underlying} = client, pid) do
    true = Process.link(underlying)
    loop(client, pid)
  end

  defp loop(client, pid) do
    msg = Socket.Web.recv!(client)
    Kernel.send(pid, {:receive, msg})
    loop(client, pid)
  end

  def handle_info({:receive, {:binary, data}}, state) do
    <<msg_type::integer-little-size(32), msg_data::binary>> = data
    %Network.Message{type: msg_type, data: msg_data, conn: self()}
    |> Network.EventManager.fire_message
    {:noreply, state}
  end

  def handle_call({:send, buffer}, _sender, client) do
    Socket.Web.send!(client, {:binary, Base.encode64(buffer)})
    {:reply, :ok, client}
  end

  ### Client API

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def send(pid, buffer) do
    GenServer.call(pid, {:send, buffer})
  end
end

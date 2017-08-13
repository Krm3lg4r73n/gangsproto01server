require Logger
alias GangsServer.Network
alias Network.Websocket.Connection

defmodule Network.Websocket.Connection do
  use GenServer

  defstruct [client: nil, receiving: false]

  ### GenServer API

  def init(client) do
    Socket.Web.accept!(client)
    state = %Connection{client: client, receiving: false}
    {:ok, state}
  end

  def handle_info({:receive, {:binary, data}}, state) do
    <<msg_type::integer-little-size(32), msg_data::binary>> = data
    %Network.Message{type: msg_type, data: msg_data, conn: self()}
    |> Network.EventManager.fire_message
    {:noreply, state}
  end
  def handle_info({:receive, {:close, _, _}}, state) do
    Process.exit(self(), :normal)
    {:noreply, state}
  end

  def handle_call({:send, buffer}, _sender, state) do
    Socket.Web.send!(state.client, {:binary, buffer})
    {:reply, :ok, state}
  end
  def handle_call({:begin_recv}, _sender, %Connection{client: client, receiving: false}) do
    conn_pid = self()
    spawn_link(fn -> loop(client, conn_pid) end)
    {:reply, :ok, %Connection{client: client, receiving: true}}
  end

  defp loop(client, conn_pid) do
    case Socket.Web.recv(client) do
      {:ok, msg} -> Kernel.send(conn_pid, {:receive, msg})
      {:error, _} -> Process.exit(self(), :normal)
    end
    loop(client, conn_pid)
  end

  ### Client API

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def begin_recv(pid) do
    GenServer.call(pid, {:begin_recv})
  end

  def send(pid, buffer) do
    GenServer.call(pid, {:send, buffer})
  end
end

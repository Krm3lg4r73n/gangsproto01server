require Logger

defmodule GangsServer.Connection do
  use GenServer

  ### GenServer API

  def init(conn) do
    {:ok, %{conn: conn, buffer: <<>>}}
  end

  def handle_call({:send, data}, _sender, %{conn: conn} = state) do
    :ok = :gen_tcp.send(conn, data)
    {:reply, :ok, state}
  end

  def handle_info({:tcp, _socket, data}, %{buffer: buffer} = state) do
    newBuffer = buffer <> data
    |> GangsServer.MessageReader.read
    {:noreply, %{state | buffer: newBuffer}}
  end

  ### Client API

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def send(pid, buffer) do
    GenServer.call(pid, {:send, buffer})
  end
end

require Logger
alias GangsServer.Network

defmodule Network.TCP.Connection do
  use GenServer

  ### GenServer API

  def init(client) do
    {:ok, %{client: client, buffer: <<>>}}
  end

  def handle_call({:send, data}, _sender, %{client: client} = state) do
    :ok = :gen_tcp.send(client, data)
    {:reply, :ok, state}
  end

  def handle_info({:tcp, _socket, data}, %{buffer: buffer} = state) do
    IO.inspect(data)
    newBuffer = buffer <> data
    |> Network.TCP.MessageReader.read(self())
    {:noreply, %{state | buffer: newBuffer}}
  end
  def handle_info({:tcp_closed, _socket}, _state) do
    exit(:normal)
  end

  ### Client API

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def send(pid, buffer) do
    GenServer.call(pid, {:send, buffer})
  end
end

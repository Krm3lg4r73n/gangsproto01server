require Logger
alias GangsServer.Network

defmodule Network.Web.WebsocketHandler do
  @behaviour :cowboy_websocket_handler
  @silence_timeout 10000

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    :ok = Network.ConnectionMonitor.monitor(self())
    {:ok, req, :nostate, @silence_timeout}
  end
  
  def websocket_handle({:binary, data}, req, state) do
    <<msg_type::integer-little-size(32), msg_data::binary>> = data
    Network.EventManager.fire_message(
      self(),
      %Network.Message{type: msg_type, data: msg_data})

    {:ok, req, state}
  end

  def websocket_info({:send, data}, req, state) do
    {:reply, {:binary, data}, req, state}
  end
  def websocket_info(message, req, state) do
    Logger.debug("Network.WebsocketHandler received unhandled info #{inspect message}")
    {:ok, req, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    IO.puts "called websocket_terminate"
    :ok
  end
end

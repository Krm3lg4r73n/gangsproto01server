alias GangsServer.{Messaging, Message}

defmodule Messaging.Handler.Ping do
  def handle({:message, %Message.Ping{}}, %{conn_pid: conn_pid}) do
    Message.Pong.new()
    |> Messaging.Message.send(conn_pid)
    :halt
  end

  def handle(_, _), do: :cont
end

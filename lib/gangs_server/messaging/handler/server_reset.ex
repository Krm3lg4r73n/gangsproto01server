alias GangsServer.{Messaging, Message}

defmodule Messaging.Handler.ServerReset do
  def handle({:message, %Message.ServerReset{}}, conn_state) do
    Messaging.UserConnectionRegistry.values()
    |> Enum.filter(fn elem -> elem != conn_state.conn_pid end)
    |> Enum.each(&Process.exit(&1, :reset))
    :halt
  end

  def handle(_, _), do: :cont
end

alias GangsServer.{User, Messaging}

defmodule User.Message do
  def send(message, pid) do
    {:ok, conn} = User.ConnectionRegistry.translate_pid(pid)
    message
    |> Messaging.Message.send(conn)
  end
end

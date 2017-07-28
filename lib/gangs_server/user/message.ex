alias GangsServer.{User, Messaging}

defmodule User.Message do
  def send(message, pid) when is_pid(pid) do
    {:ok, conn} = User.ConnectionRegistry.translate_pid(pid)
    message
    |> Messaging.Message.send(conn)
  end
  def send(message, user) do
    {:ok, pid} = User.UserRegistry.translate_key(user)
    {:ok, conn} = User.ConnectionRegistry.translate_pid(pid)
    message
    |> Messaging.Message.send(conn)
  end
end

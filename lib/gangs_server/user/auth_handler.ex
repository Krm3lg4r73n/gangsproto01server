require Logger
alias GangsServer.{User, Messaging, Message}

defmodule User.AuthHandler do
  use GenEvent

  def handle_event({:message, message}, _state) do
    process_message(message.message, message.conn)
    {:ok, nil}
  end
  def handle_event({:disconnected, conn}, _state) do
    case User.ConnectionRegistry.translate_key(conn) do
      {:ok, user_pid} ->
        User.Process.disconnect(user_pid)
        User.ConnectionRegistry.unregister_by_pid(user_pid)
        User.UserRegistry.unregister_by_pid(user_pid)
      :error -> nil
    end
    {:ok, nil}
  end
  def handle_event(_event, _state), do: {:ok, nil}

  defp process_message(%Message.User{name: name}, conn) do
    case User.AuthPolicy.verify(name) do
      {:ok, user} -> process_conn(conn, user)
      :error -> reject_conn(conn)
    end
  end
  defp process_message(message, conn) do
    case User.ConnectionRegistry.translate_key(conn) do
      {:ok, user_pid} -> User.Process.handle_message(user_pid, message)
      :error -> nil
    end
  end

  defp process_conn(conn, user) do
    {:ok, user_pid} = Supervisor.start_child(
      User.Process.Supervisor,
      [user])
    User.ConnectionRegistry.register(conn, user_pid)
    User.UserRegistry.register(user, user_pid)
    #TODO: test for errors and kill process
  end

  defp reject_conn(conn) do
    %Message.ClientError{error: "unauthenticated"}
    |> Messaging.Message.send(conn)
  end
end

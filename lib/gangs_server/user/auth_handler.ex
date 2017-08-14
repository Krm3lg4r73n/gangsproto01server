require Logger
alias GangsServer.{User, Messaging, Message, Game}

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
    case User.Policy.Auth.verify(name) do
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
    case {
      User.ConnectionRegistry.test_key(conn),
      User.UserRegistry.test_key(user.id)
    } do
      {:ok, :ok} -> attach_user(conn, user)
      _ -> reject_conn(conn)
    end
  end

  defp attach_user(conn, user) do
    {:ok, user_pid} = Supervisor.start_child(
                      User.Process.Supervisor,
                      [user])
    User.ConnectionRegistry.register(conn, user_pid)
    User.UserRegistry.register(user.id, user_pid)

    Game.Systems.attach_user_process(user_pid)

    Message.Ok.new
    |> Messaging.Message.send(conn)
  end

  defp reject_conn(conn) do
    Message.Error.new(type: "unauthenticated")
    |> Messaging.Message.send(conn)
  end
end

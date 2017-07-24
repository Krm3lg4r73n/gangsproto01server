require Logger
alias GangsServer.{User, Messaging, Message, Store}

defmodule User.AuthHandler do
  use GenEvent

  def handle_event({:message, message}, _state) do
    process_message(message.message, message.conn)
    {:ok, nil}
  end
  def handle_event({:disconnected, conn}, _state) do
    case User.Registry.translate_conn(conn) do
      {:ok, user} ->
        # kill user process
        User.Registry.remove(conn)
      :error -> nil
    end
    {:ok, nil}
  end
  def handle_event(_event, _state), do: {:ok, nil}

  defp process_message(%Message.User{name: name}, conn) do
    case authenticate_user(name) do
      {:ok, user} -> process_conn(conn, user)
      :error -> reject_conn(conn)
    end
  end
  defp process_message(message, conn) do
    case User.Registry.translate_conn(conn) do
      {:ok, user} -> nil # relay message to user process
      :error -> nil
    end
  end

  defp authenticate_user(name) do
    case Store.Repo.get_by(Store.Schemas.User, name: name) do
      nil -> :error
      user -> {:ok, user}
    end
  end

  defp process_conn(conn, user) do
    case User.Registry.add(conn, user) do
      :ok -> nil # start new user process
      :error -> reject_conn(conn)
    end
  end

  defp reject_conn(conn) do
    %Message.ClientError{error: "unauthenticated"}
    |> Messaging.Message.send(conn)
  end
end

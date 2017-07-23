require Logger
alias GangsServer.{Auth, Messaging, Message, Store}

defmodule Auth.LoginHandler do
  use GenEvent

  def handle_event({:message, message}, _state) do
    process_message(message.message, message.conn)
    {:ok, nil}
  end
  def handle_event({:disconnected, conn}, _state) do
    case Auth.Dictionary.translate_conn(conn) do
      {:ok, user} ->
        Auth.EventManager.fire_user_disconnected(user)
        Auth.Dictionary.remove(conn)
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
    case Auth.Dictionary.translate_conn(conn) do
      {:ok, user} -> fire_message(message, user)
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
    case Auth.Dictionary.add(conn, user) do
      :ok -> Auth.EventManager.fire_user_connected(user)
      :error -> reject_conn(conn)
    end
  end

  defp reject_conn(conn) do
    msg = %Message.ClientError{error: "unauthenticated"}
    %Messaging.Message{message: msg, conn: conn}
    |> Messaging.Message.send
  end

  defp fire_message(message, user) do
    %Auth.Message{message: message, user: user}
    |> Auth.EventManager.fire_message
  end
end

require Logger
alias GangsServer.{Auth, Message, Store}

defmodule Auth.LoginHandler do
  use GenEvent

  def handle_event({:message, message}, _state) do
    process_message(message.message, message.connection)
    {:ok, nil}
  end
  def handle_event({:disconnected, connection}, _state) do
    case Auth.Dictionary.translate(connection) do
      {:ok, user} ->
        Auth.EventManager.fire_user_disconnected(user)
        Auth.Dictionary.remove(connection)
      :error -> nil
    end
    {:ok, nil}
  end
  def handle_event(_event, _state), do: {:ok, nil}

  defp process_message(%Message.User{name: name}, connection) do
    case authenticate_user(name) do
      {:ok, user} ->
        Auth.Dictionary.add(connection, user)
        Auth.EventManager.fire_user_connected(user)
      :error -> reject_user(connection)
    end
  end
  defp process_message(message, connection) do
    case Auth.Dictionary.translate(connection) do
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

  defp reject_user(conn) do
    Logger.debug "Rejecting #{inspect(conn)}"
  end

  defp fire_message(message, user) do
    %Auth.Message{message: message, user: user}
    |> Auth.EventManager.fire_message
  end
end

require Logger
alias GangsServer.{Messaging, Network, Message}

defmodule Messaging.Message do
  defstruct [:message, :conn]

  def send(message, conn_pid) do
    log_message(message, conn_pid)
    data = message.__struct__.encode(message)
    type = Messaging.Dictionary.translate_message(message)
    Network.Message.send(type, data, conn_pid)
  end

  defp log_message(%Message.Pong{}, _conn_pid), do: nil
  defp log_message(message, conn_pid) do
    Logger.info "Sending to #{inspect(conn_pid)} #{inspect(message)}"
  end

  def send_to_user(message, user_id) do
    case Messaging.UserConnectionRegistry.translate_key(user_id) do
      {:ok, conn_pid} -> Messaging.Message.send(message, conn_pid)
      :error -> Logger.debug "Sending #{inspect(message)} to user #{user_id} without connection"
    end
  end
end

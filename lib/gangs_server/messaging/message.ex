require Logger
alias GangsServer.{Messaging, Network}

defmodule Messaging.Message do
  defstruct [:message, :conn]

  def send(message, conn_pid) do
    data = message.__struct__.encode(message)
    type = Messaging.Dictionary.translate_message(message)
    Network.Message.send(type, data, conn_pid)
  end

  def send_to_user(message, user_id) do
    case Messaging.UserConnectionRegistry.translate_key(user_id) do
      {:ok, conn_pid} -> Messaging.Message.send(message, conn_pid)
      :error -> Logger.debug "Sending #{inspect(message)} to user #{user_id} without connection"
    end
  end
end

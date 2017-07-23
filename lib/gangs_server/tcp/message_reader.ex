alias GangsServer.TCP

defmodule TCP.MessageReader do
  @head_size 8

  def read(buffer, conn) do
    read_messages({:ok, buffer, conn})
  end

  defp read_messages({:missing_data, buffer, _conn}), do: buffer
  defp read_messages({:ok, buffer, conn}) do
    buffer
    |> try_read_message(conn)
    |> read_messages
  end

  defp try_read_message(buffer, conn) when byte_size(buffer) <= @head_size, do: {:missing_data, buffer, conn}
  defp try_read_message(buffer, conn) do
    case buffer do
      <<msg_type::integer-little-size(32),
        msg_size::integer-little-size(32),
        remaining::binary>> ->
        case remaining do
          <<msg_data::binary-size(msg_size), remaining::binary>> ->
            process_message(msg_type, msg_data, conn)
            {:ok, remaining, conn}
          _ -> {:missing_data, buffer, conn}
        end
      _ -> {:missing_data, buffer, conn}
    end
  end

  defp process_message(msg_type, msg_data, conn) do
    %TCP.Message{type: msg_type, data: msg_data, conn: conn}
    |> TCP.EventManager.fire_message
  end
end

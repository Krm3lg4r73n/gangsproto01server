defmodule GangsServer.MessageReader do

  @head_size 8

  def read(buffer) do
    read_messages({:ok, buffer})
  end

  defp read_messages({:missing_data, buffer}), do: buffer
  defp read_messages({:ok, buffer}) do
    buffer
    |> try_read_message
    |> read_messages
  end

  defp try_read_message(buffer) when byte_size(buffer) <= @head_size, do: {:missing_data, buffer}
  defp try_read_message(buffer) do
    case buffer do
      <<msg_type::integer-little-size(32),
        msg_size::integer-little-size(32),
        remaining::binary>> ->
        case remaining do
          <<msg_data::binary-size(msg_size), remaining::binary>> ->
            GangsServer.MessageParser.parse(msg_type, msg_data)
            {:ok, remaining}
          _ -> {:missing_data, buffer}
        end
      _ -> {:missing_data, buffer}
    end
  end
end

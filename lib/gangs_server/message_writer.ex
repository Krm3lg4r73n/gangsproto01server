alias GangsServer.TCP

defmodule GangsServer.MessageWriter do
  def write(conn, msg_type, msg_data) do
    msg_size = byte_size(msg_data)
    buffer = <<msg_type::integer-little-size(32)>> <>
             <<msg_size::integer-little-size(32)>> <>
             msg_data
    TCP.Connection.send(conn, buffer)
  end
end

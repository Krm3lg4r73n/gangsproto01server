alias GangsServer.TCP

defmodule TCP.Message do
  defstruct [:type, :data, :conn]

  def send(type, data, conn) do
    size = byte_size(data)
    buffer = <<type::integer-little-size(32)>> <>
             <<size::integer-little-size(32)>> <>
             data
    TCP.Connection.send(conn, buffer)
  end
end

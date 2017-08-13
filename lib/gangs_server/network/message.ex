alias GangsServer.Network

defmodule Network.Message do
  defstruct [:type, :data, :conn]

  def send(type, data, conn) do
    # size = byte_size(data)
    # buffer = <<type::integer-little-size(32)>> <>
    #          <<size::integer-little-size(32)>> <>
    #          data
    # Network.TCP.Connection.send(conn, buffer)
    buffer = <<type::integer-little-size(32), data::binary>>
    GenServer.call(conn, {:send, buffer})
  end
end

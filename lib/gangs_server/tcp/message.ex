alias GangsServer.TCP

defmodule TCP.Message do
  defstruct [:type, :data, :conn]

  def send(%TCP.Message{type: type, data: data, conn: conn}) do
    TCP.MessageWriter.write(conn, type, data)
  end
end

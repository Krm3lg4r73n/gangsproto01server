alias GangsServer.{Network, Message}

defmodule Tester do
  def run(cnt, size) do
    send_message(size)
    if cnt > 1, do: run(cnt-1, size)
  end

  def send_message(size) do
    data = Message.Person.new(
      name: random_string(size)
    )
    |> IO.inspect
    |> Message.Person.encode

    Network.Message.send(501, data, :conn)
  end

  def send_websocket_message(size) do
    Network.Websocket.Connection.send(:conn, random_string(size))
  end

  def random_string(size) do
    length = :rand.uniform(size)
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end

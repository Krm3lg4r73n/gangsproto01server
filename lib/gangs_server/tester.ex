defmodule Tester do
  def run(cnt, size) do
    send_message(size)
    if cnt > 1, do: run(cnt-1, size)
  end

  def send_message(size) do
    data = GangsServer.Messages.Person.new(
      name: random_string(size)
    )
    |> IO.inspect
    |> GangsServer.Messages.Person.encode

    GangsServer.MessageWriter.write(:conn, 0, data)
  end

  def random_string(size) do
    length = :rand.uniform(size)
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end

defmodule GangsServer do
  def run(%{port: port}) do
    port
    |> GangsServer.TCP.Server.listen
  end
end

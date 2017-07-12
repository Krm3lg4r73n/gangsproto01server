require Logger
alias GangsServer.TCP

defmodule GangsServer do
  def run(%{port: port}) do
    port
    |> TCP.Server.listen
  end
end

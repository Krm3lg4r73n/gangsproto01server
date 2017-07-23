require Logger
alias GangsServer.{Game, Auth, Message}

defmodule Game.LobbyHandler do
  use GenEvent

  def handle_event({:connected, user}, _state) do
    Message.Bootstrap.new(worlds: ["world0", "world1"], users: ["user0", "user1"])
    |> Auth.Message.send(user)
    {:ok, nil}
  end
  def handle_event(_event, _state), do: {:ok, nil}
end

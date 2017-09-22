alias GangsServer.{Messaging, Message}
alias GangsServer.GlobalEventManager, as: GEM

defmodule Messaging.Handler.PlayerCreate do
  def handle({:message, %Message.PlayerCreate{} = player}, state) do
    GEM.invoke({
      :player_create_req,
      state.user_id,
      state.world_id,
      player.name})
    :halt
  end

  def handle(_, _), do: :cont
end

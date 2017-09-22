alias GangsServer.{Messaging, Message}
alias GangsServer.GlobalEventManager, as: GEM

defmodule Messaging.Handler.WorldCreate do
  def handle({:message, %Message.WorldCreate{key: key}}, state) do
    GEM.invoke({:world_create_req, state.user_id, key})
    :halt
  end

  def handle(_, _), do: :cont
end

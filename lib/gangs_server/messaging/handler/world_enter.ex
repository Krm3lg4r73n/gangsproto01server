alias GangsServer.{Messaging, Message, Util}
alias GangsServer.GlobalEventManager, as: GEM

defmodule Messaging.Handler.WorldEnter do
  def handle({:message, %Message.WorldJoin{}}, %{world_id: _} = state) do
    Util.send_conn_error(state.conn_pid, "Already joined")
    :halt
  end
  def handle({:message, %Message.WorldJoin{key: key}}, state) do
    GEM.invoke({:user_enter_world_req, state.user_id, key})
    :halt
  end

  def handle(:disconnect, %{world_id: _} = state) do
    GEM.invoke({:user_exit_world_req, state.user_id, state.world_id})
    :cont
  end

  def handle(_, %{world_id: _}), do: :cont
  def handle(_, _), do: :halt
end

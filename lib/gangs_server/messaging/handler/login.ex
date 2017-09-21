require Logger
alias GangsServer.{Messaging, Message, Util}
alias GangsServer.GlobalEventManager, as: GEM

defmodule Messaging.Handler.Login do
  def handle({:message, %Message.User{name: name}}, state) do
    if Map.has_key?(state, :user_id) do
      Util.send_conn_error(state.conn_pid, "Already logged in")
    else
      GEM.invoke({:user_login_req, state.conn_pid, name})
    end
    :halt
  end
  def handle(_, %{user_id: _}), do: :cont
  def handle(_, _), do: :halt
end

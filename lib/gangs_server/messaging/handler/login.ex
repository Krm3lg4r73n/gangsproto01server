alias GangsServer.{Messaging, Message, Util}
alias GangsServer.GlobalEventManager, as: GEM

defmodule Messaging.Handler.Login do
  def handle({:message, %Message.User{name: name}}, conn_state) do
    if Map.has_key?(conn_state, :user_id) do
      Util.send_conn_error(conn_state.conn_pid, "Already logged in")
    else
      GEM.invoke({:user_login_req, conn_state.conn_pid, name})
    end
    :halt
  end

  def handle(:disconnect, %{user_id: user_id}) do
    GEM.invoke({:user_logout, user_id})
    :cont
  end

  def handle(_, %{user_id: _}), do: :cont
  def handle(_, _), do: :halt
end

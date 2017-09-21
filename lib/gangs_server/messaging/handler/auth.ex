require Logger
alias GangsServer.{Messaging, Message, Store, Util}

defmodule Messaging.Handler.Auth do
  def handle(:connect, state) do
    {:cont, Map.put(state, :user_id, nil)}
  end

  def handle({:message, %Message.User{name: name}}, %{user_id: nil} = state) do
    case Store.Interactor.User.get_by_name(name) do
      nil -> Util.send_conn_error(state.conn_pid, "Unknown")
             {:halt, state}
      user -> Util.send_conn_ok(state.conn_pid)
              {:halt, %{state | user_id: user.id}}
    end
  end
  def handle({:message, %Message.User{}}, state) do
    Util.send_conn_error(state.conn_pid, "Already logged in")
    {:halt, state}
  end

  def handle(_, %{user_id: nil} = state), do: {:halt, state}
  def handle(_, state), do: {:cont, state}
end

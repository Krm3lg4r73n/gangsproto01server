alias GangsServer.{Messaging, Util}

defmodule Messaging.Observer.Login do
  def observe({:user_login, user, conn_pid}) do
    Messaging.ConnectionState.put(conn_pid, :user_id, user.id)
    :ok = Messaging.UserConnectionRegistry.register(user.id, conn_pid)
    Util.send_conn_ok(conn_pid)
  end

  def observe({:user_login_fail, conn_pid, reason}) do
    Util.send_conn_error(conn_pid, reason)
  end

  def observe(_), do: nil
end

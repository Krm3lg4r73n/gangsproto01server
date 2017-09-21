alias GangsServer.{Messaging, Util}

defmodule Messaging.Observer.LoginResult do
  def observe({:user_login_succ, conn_pid, user_id}) do
    Messaging.ConnectionState.put(conn_pid, :user_id, user_id)
    Util.send_conn_ok(conn_pid)
  end
  def observe({:user_login_fail, conn_pid}) do
    Util.send_conn_error(conn_pid, "Login failed")
  end
  def observe(_), do: nil
end

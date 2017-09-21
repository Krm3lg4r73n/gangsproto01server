alias GangsServer.{User, Store}
alias GangsServer.GlobalEventManager, as: GEM

defmodule User.Observer.Login do
  def observe({:user_login_req, conn_pid, name}) do
    Store.Interactor.User.get_by_name(name)
    |> process_user(conn_pid)
  end
  def observe(_), do: nil

  defp process_user(nil, conn_pid) do
    GEM.invoke({:user_login_fail, conn_pid})
  end
  defp process_user(user, conn_pid) do
    GEM.invoke({:user_login_succ, conn_pid, user.id})
  end
end

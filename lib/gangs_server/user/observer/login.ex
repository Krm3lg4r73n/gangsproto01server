alias GangsServer.{User, Store}
alias GangsServer.GlobalEventManager, as: GEM

defmodule User.Observer.Login do
  def observe({:user_login_req, conn_pid, name}) do
    case Store.Interactor.User.get_by_name(name) do
      nil -> GEM.invoke({:user_login_fail, conn_pid, "User unknown"})
      user ->
        case User.State.lookup(user.id) do
          nil ->
            # TODO: make atomic
            User.State.put(user.id, :logged_in, true)
            GEM.invoke({:user_login, user, conn_pid})
          _ -> GEM.invoke({:user_login_fail, conn_pid, "Already logged in"})
        end
    end
  end

  def observe({:user_logout, user_id}) do
    User.State.drop(user_id)
  end

  def observe(_), do: nil
end

alias GangsServer.Messaging

defmodule Messaging.Observer.WorldEnter do
  def observe({:user_enter_world, world_id, user_id}) do
    {:ok, conn_pid} = Messaging.UserConnectionRegistry.translate_key(user_id)
    Messaging.ConnectionState.put(conn_pid, :world_id, world_id)
  end

  def observe(_), do: nil
end

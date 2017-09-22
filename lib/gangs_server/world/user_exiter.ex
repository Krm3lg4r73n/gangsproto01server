alias GangsServer.World

defmodule World.UserExiter do
  def exit_user(world_id, user_id) do
    case World.State.lookup(world_id) do
      %{users: users} ->
        if MapSet.member?(users, user_id) do
          World.State.put(world_id, :users, MapSet.delete(users, user_id))
          :ok
        else
          :error
        end
      _ -> :error
    end
  end
end

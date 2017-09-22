alias GangsServer.{World, Store}

defmodule World.UserEnterer do
  def enter_user(key, user_id) do
    with {:ok, world} <- load_world(key),
         :ok <- add_user(world, user_id) do
      {:ok, world.id}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp load_world(key) do
    case Store.Interactor.World.get_by_key(key) do
      nil -> {:error, "World unknown"}
      world -> {:ok, world}
    end
  end

  defp add_user(world, user_id) do
    case World.State.lookup(world.id) do
      %{users: users} ->
        if MapSet.member?(users, user_id) do
          {:error, "User already entered"}
        else
          World.State.put(world.id, :users, MapSet.put(users, user_id))
          :ok
        end
      _ ->
        World.State.put(world.id, :users, MapSet.new([user_id]))
        :ok
    end
  end
end

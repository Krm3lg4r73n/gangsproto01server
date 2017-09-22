alias GangsServer.World
alias GangsServer.GlobalEventManager, as: GEM

defmodule World.Observer.Enter do
  def observe({:user_enter_world_req, user_id, key}) do
    case World.UserEnterer.enter_user(key, user_id) do
      {:ok, world_id} -> GEM.invoke({:user_enter_world, world_id, user_id})
      {:error, reason} -> GEM.invoke({:user_enter_world_fail, user_id, reason})
    end
  end

  def observe({:user_exit_world_req, user_id, world_id}) do
    case World.UserExiter.exit_user(world_id, user_id) do
      :ok -> GEM.invoke({:user_exit_world, world_id, user_id})
      :error -> GEM.invoke({:user_exit_world_fail, world_id, user_id})
    end
  end

  def observe(_), do: nil
end

alias GangsServer.World
alias GangsServer.GlobalEventManager, as: GEM

defmodule World.Observer.Create do
  def observe({:world_create_req, user_id, key}) do
    case World.Creator.create(key) do
      {:ok, world} -> GEM.invoke({:world_create, world, user_id})
      {:error, reason} -> GEM.invoke({:world_create_fail, user_id, reason})
    end
  end

  def observe(_), do: nil
end

alias GangsServer.{GameSystem, Store, Util}
alias GangsServer.GlobalEventManager, as: GEM

defmodule GameSystem.Player.Observer do
  def observe({:user_enter_world, world_id, user_id}) do
    case Store.Interactor.Player.get(user_id, world_id) do
      nil -> GEM.invoke({:user_missing_player, user_id})
      player -> GEM.invoke({:user_attach_to_player, player})
    end
  end

  def observe({:player_create_req, user_id, world_id, name}) do
    case Store.Interactor.Player.create(user_id, world_id, name) do
      {:ok, player} ->
        GEM.invoke({:player_create, player})
      {:error, changeset} -> invoke_fail(user_id, changeset)
    end
  end

  def observe(_), do: nil

  defp invoke_fail(user_id, changeset) do
    GEM.invoke({
      :player_create_fail,
      user_id,
      Util.stringify_changeset_errors(changeset)})
  end
end

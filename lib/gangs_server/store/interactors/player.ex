alias GangsServer.Store
alias Store.Schema.Player

defmodule Store.Interactor.Player do
  import Ecto.Query

  def get(user_id, world_id) do
    query = from p in Player,
            where: p.user_id == ^user_id,
            where: p.world_id == ^world_id
    Store.Repo.one(query)
  end

  def create(user_id, world_id, name) do
    Player.changeset(%Player{}, %{
      name: name,
      user_id: user_id,
      world_id: world_id})
    |> Store.Repo.insert
  end
end

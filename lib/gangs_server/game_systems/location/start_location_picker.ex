alias GangsServer.{GameSystem.Location, Store}

defmodule Location.StartLocationPicker do
  def pick(_world_id, _player_id) do
    # TODO: choose customized homebase start location
    Store.Interactor.Location.get_by_ref("new_earth.bar")
  end
end



alias GangsServer.{GameSystem.Location, Store}

defmodule Location.Recorder do
  require Logger

  def record(player_id, location_ref) do
    Logger.info "Recording location #{player_id} @ #{location_ref}"
  end

  def current_player_location(_player_id) do
    Store.Interactor.Location.get_by_ref("new_earth.harbour")
  end
end

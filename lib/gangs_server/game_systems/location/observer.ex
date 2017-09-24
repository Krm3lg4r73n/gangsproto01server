alias GangsServer.GameSystem.Location
alias GangsServer.GlobalEventManager, as: GEM

defmodule Location.Observer do
  def observe({:player_create, player}) do
    Location.StartLocationPicker.pick(player.world_id, player.id)
    |> player_enter_location(player)
  end

  def observe({:user_attach_to_player, player}) do
    location = Location.Recorder.current_player_location(player.id)
    GEM.invoke({:user_update_location, player.user_id, location})
  end

  def observe(_), do: nil

  defp player_enter_location(location, player) do
    Location.Recorder.record(player.id, location.ref_name)
    GEM.invoke({:player_enter_location, player, location})
  end
end

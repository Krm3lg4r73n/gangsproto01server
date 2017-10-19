alias GangsServer.GameSystem.Scene
alias GangsServer.GlobalEventManager, as: GEM

defmodule Scene.Observer do
  def observe({:player_enter_location, player, location}) do
    start_scene(player, location)
  end

  def observe({:user_attach_to_player, player}) do
  end

  def observe(_), do: nil

  defp start_scene(player, location) do
    {:ok, pid} = Supervisor.start_child(
      Scene.Supervisor, [{player, location}])
  end
end

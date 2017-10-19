require Logger
alias GangsServer.GameSystem.Scene

defmodule Scene.Process do
  use GenServer

  def init({player, location}) do
    Logger.info "Starting Scene for #{player.name} at #{location.ref_name}"
    {:ok, {player, location}}
  end

  def start_link(state, opts \\ []), do: GenServer.start_link(__MODULE__, state, opts)
end

alias GangsServer.Game

defmodule Game.EventManager do
  use GenServer

  @observer [
    Game.Location.Observer
  ]

  def init(:ok) do
    {:ok, MapSet.new(@observer)}
  end

  def handle_call({:register_obs, new_obs}, _, obs) do
    {:reply, :ok, MapSet.put(obs, new_obs)}
  end

  def handle_cast({:invoke, event}, obs) do
    Enum.each(obs, &observe_event(&1, event))
    {:noreply, obs}
  end

  defp observe_event(obs, event) do
    obs.observe(event)
  end

  def start_link(opts \\ []), do: GenServer.start_link(__MODULE__, :ok, opts)
  def register_obs(obs), do: GenServer.call(__MODULE__, {:register_obs, obs})
  def invoke(event), do: GenServer.cast(__MODULE__, {:invoke, event})
end

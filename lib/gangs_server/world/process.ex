require Logger
alias GangsServer.{World, GameSystem}

defmodule World.Process do
  use GenServer

  defstruct [:world, :user_ids]

  def init(world) do
    state = %World.Process{
      world: world,
      user_ids: MapSet.new,
    }

    Logger.debug "Starting Process for #{state.world}"
    {:ok, state}
  end

  def handle_call({:user_enter, user_id}, _, state) do
    unless MapSet.member?(state.user_ids, user_id) do
      new_user_ids = MapSet.put(state.user_ids, user_id)
      process_user_enter(user_id, state.world)
      {:reply, :ok, %{state | user_ids: new_user_ids}}
    else
      {:reply, :ok, state}
    end
  end

  def handle_call({:user_exit, user_id}, _, state) do
    if MapSet.member?(state.user_ids, user_id) do
      process_user_exit(user_id, state.world)
      {:reply, :ok, %{state | user_ids: MapSet.delete(state.user_ids, user_id)}}
    else
      {:reply, :ok, state}
    end
  end

  def handle_call({:user_message, message, user_id}, _, state) do
    if MapSet.member?(state.user_ids, user_id) do
      process_user_message(user_id, state.world, message)
    end
    {:reply, :ok, state}
  end

  defp process_user_enter(user_id, world) do
    Logger.info "User #{user_id} entered #{world}"
    GameSystem.Player.user_enter(user_id, world.id)
  end

  defp process_user_exit(user_id, world) do
    Logger.info "User #{user_id} left #{world}"
  end

  defp process_user_message(user_id, world, message) do
    GameSystem.Player.user_message(message, user_id, world.id)
  end

  #==============

  def start_link(state, opts \\ []), do: GenServer.start_link(__MODULE__, state, opts)
  def user_enter(pid, user_id), do: GenServer.call(pid, {:user_enter, user_id})
  def user_exit(pid, user_id), do: GenServer.call(pid, {:user_exit, user_id})
  def user_message(pid, message, user_id), do: GenServer.call(pid, {:user_message, message, user_id})
end

require Logger
alias GangsServer.{World, Util, Message, User, GameSystem}

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
    new_user_ids = if MapSet.member?(state.user_ids, user_id) do
      Util.send_user_error(user_id, "Already entered")
      state.user_ids
    else
      enter_user(user_id, state.world)
      MapSet.put(state.user_ids, user_id)
    end
    {:reply, :ok, %{state | user_ids: new_user_ids}}
  end

  def handle_call({:user_exit, user_id}, _, state) do
    Logger.info "User #{user_id} left #{state.world}"

    new_user_ids = if MapSet.member?(state.user_ids, user_id) do
      MapSet.delete(state.user_ids, user_id)
    else
      state.user_ids
    end
    {:reply, :ok, %{state | user_ids: new_user_ids}}
  end

  def handle_call({:user_message, message, user_id}, _, state) do
    GameSystem.Player.user_message(message, user_id, state.world.id)
    {:reply, :ok, state}
  end

  defp enter_user(user_id, world) do
    Logger.info "User #{user_id} entered #{world}"
    GameSystem.Player.user_enter(user_id, world.id)
  end

  #==============

  def start_link(state, opts \\ []), do: GenServer.start_link(__MODULE__, state, opts)
  def user_enter(pid, user_id), do: GenServer.call(pid, {:user_enter, user_id})
  def user_exit(pid, user_id), do: GenServer.call(pid, {:user_exit, user_id})
  def user_message(pid, message, user_id), do: GenServer.call(pid, {:user_message, message, user_id})
end

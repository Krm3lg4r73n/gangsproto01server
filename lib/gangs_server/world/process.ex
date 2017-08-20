require Logger
alias GangsServer.{World, Util, Message, User}

defmodule World.Process do
  use GenServer

  defstruct [:world, :user_pids]

  def init(world) do
    state = %World.Process{
      world: world,
      user_pids: MapSet.new,
    }

    Logger.debug "Starting Process for #{state.world}"
    {:ok, state}
  end

  def handle_call({:user_enter, user_pid}, _from, state) do
    new_user_pids = if MapSet.member?(state.user_pids, user_pid) do
      Util.send_user_error(user_pid, "Already entered")
      state.user_pids
    else
      enter_user(user_pid, state.world)
      MapSet.put(state.user_pids, user_pid)
    end
    {:reply, :ok, %{state | user_pids: new_user_pids}}
  end

  def handle_call({:user_exit, user_pid}, _from, state) do
    Logger.info "User #{inspect(user_pid)} left #{state.world}"

    new_user_pids = if MapSet.member?(state.user_pids, user_pid) do
      MapSet.delete(state.user_pids, user_pid)
    else
      state.user_pids
    end
    {:reply, :ok, %{state | user_pids: new_user_pids}}
  end

  defp enter_user(user_pid, world) do
    Logger.info "User #{inspect(user_pid)} entered #{world}"

    # get player for user
      # no player -> create player msg
      # player -> player in state
    Message.WorldJoined.new(world_id: world.id)
    |> User.Message.send(user_pid)
  end

  #==============

  def start_link(state, opts \\ []), do: GenServer.start_link(__MODULE__, state, opts)
  def user_enter(pid, user_pid), do: GenServer.call(pid, {:user_enter, user_pid})
  def user_exit(pid, user_pid), do: GenServer.call(pid, {:user_exit, user_pid})
  def user_message(pid, user_pid, message), do: GenServer.call(pid, {:user_message, user_pid, message})
end

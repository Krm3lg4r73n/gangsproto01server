require Logger
alias GangsServer.{Game, User, Message}

defmodule Game.World.Process do
  use GenServer

  def init(world) do
    Logger.debug "Starting Process for world: #{world.key}"
    {:ok, world}
  end

  def handle_call({:user_join, user_pid}, _from, world) do
    Logger.info "User #{inspect(user_pid)} joining #{world.key}"
    send_joined_message(user_pid, world.id)
    {:reply, :ok, world}
  end

  defp send_joined_message(user_pid, world_id) do
    Message.WorldJoined.new(world_id: world_id)
    |> User.Message.send(user_pid)
  end

  #==============

  def start_link(state, opts \\ []), do: GenServer.start_link(__MODULE__, state, opts)
  def user_join(pid, user_pid), do: GenServer.call(pid, {:user_join, user_pid})
end

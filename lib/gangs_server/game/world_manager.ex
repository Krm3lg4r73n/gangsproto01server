require Logger
alias GangsServer.{Game, User, Message, Store}

defmodule Game.WorldManager do
  use GenServer

  def handle_call({:create, key}, {user_pid, _call_id}, _state) do
    Logger.info "#{inspect(user_pid)} creating world #{key}"
    world_type = Store.Interactor.WorldType.get_by_ref("new_earth")
    case Store.Interactor.World.create(world_type, key) do
      {:ok, world} -> send_joined_message(user_pid, world.id)
      {:error, changeset} -> send_error_message(user_pid, changeset)
    end
    {:reply, :ok, nil}
  end

  defp send_joined_message(user_pid, world_id) do
    Message.WorldJoined.new(world_id: world_id)
    |> User.Message.send(user_pid)
  end

  defp send_error_message(user_pid, changeset) do
    errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    desc = Poison.encode!(errors)
    Message.Error.new(type: "failed_to_create_world", description: desc)
    |> User.Message.send(user_pid)
  end

  def handle_call({:join, key}, {user_pid, _call_id}, _state) do
    # TODO: check if already joined
    Logger.info "#{inspect(user_pid)} joining world #{key}"
    {:reply, :ok, nil}
  end

  #==============

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def create_world(key) do
    GenServer.call(__MODULE__, {:create, key})
  end

  def join_world(key) do
    GenServer.call(__MODULE__, {:join, key})
  end
end

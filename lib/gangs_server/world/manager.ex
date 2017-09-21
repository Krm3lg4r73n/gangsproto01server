alias GangsServer.{World, Store, Util}

defmodule World.Manager do
  use GenServer

  def init(:ok) do
    {:ok, nil}
  end

  def handle_call(:start_all, _, _) do
    Store.Interactor.World.get_all()
    |> Enum.each(fn world ->
      start_process(world)
    end)
    {:reply, :ok, nil}
  end

  def handle_call({:create, key, user_id}, _, _) do
    world_pid = case World.Creator.create(key) do
      {:ok, world} ->
        world_pid = start_process(world)
        World.Process.user_enter(world_pid, user_id)
        world_pid
      {:error, reason} ->
        Util.send_user_error(user_id, reason)
        nil
    end

    {:reply, world_pid, nil}
  end

  def handle_call({:user_enter, key, user_id}, _, _) do
    world_pid = case World.Registry.translate_key(key) do
      {:ok, world_pid} ->
        World.Process.user_enter(world_pid, user_id)
        world_pid
      :error ->
        Util.send_user_error(user_id, "World unknown")
        nil
    end
    {:reply, world_pid, nil}
  end

  defp start_process(world) do
    {:ok, world_pid} = Supervisor.start_child(
      World.Process.Supervisor,
      [world])
    World.Registry.register(world.key, world_pid)
    world_pid
  end

  #==============

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def start_all() do
    GenServer.call(__MODULE__, :start_all)
  end
  def create(key, user_id) do
    GenServer.call(__MODULE__, {:create, key, user_id})
  end
  def user_enter(key, user_id) do
    GenServer.call(__MODULE__, {:user_enter, key, user_id})
  end
end

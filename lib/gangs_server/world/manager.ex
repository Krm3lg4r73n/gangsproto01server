alias GangsServer.{World, Store, Util}

defmodule World.Manager do
  use GenServer

  def init(:ok) do
    refs = MapSet.new
    {:ok, refs}
  end

  def handle_call(:start_all, _from, refs) do
    new_refs = Store.Interactor.World.get_all()
    |> Enum.reduce(refs, fn world, acc ->
      ref = start_process(world)
      |> Process.monitor
      MapSet.put(acc, ref)
    end)
    {:reply, :ok, new_refs}
  end

  def handle_call({:create, key}, {user_pid, _}, refs) do
    world_pid = case World.Creator.create(key) do
      {:ok, world} ->
        world_pid = start_process(world)
        enter_user(:ok, world_pid, user_pid)
        world_pid
      {:error, reason} ->
        enter_user(:error, reason, user_pid)
        nil
    end

    if is_nil(world_pid) do
      {:reply, nil, refs}
    else
      ref = Process.monitor(world_pid)
      {:reply, world_pid, MapSet.put(refs, ref)}
    end
  end

  def handle_call({:user_enter, key}, {user_pid, _}, refs) do
    world_pid = case World.Registry.translate_key(key) do
      {:ok, world_pid} ->
        enter_user(:ok, world_pid, user_pid)
        world_pid
      :error ->
        enter_user(:error, "World unknown", user_pid)
        nil
    end
    {:reply, world_pid, refs}
  end

  def handle_call({:user_exit, world_pid}, {user_pid, _}, refs) do
    World.Process.user_exit(world_pid, user_pid)
    {:reply, :ok, refs}
  end

  def handle_call({:user_message, world_pid, message}, {user_pid, _}, refs) do
    World.Process.user_message(world_pid, user_pid, message)
    {:reply, :ok, refs}
  end

  defp start_process(world) do
    {:ok, world_pid} = Supervisor.start_child(
      World.Process.Supervisor,
      [world])
    World.Registry.register(world.key, world_pid)
    world_pid
  end

  defp enter_user(:error, reason, user_pid) do
    Util.send_user_error(user_pid, reason)
  end
  defp enter_user(:ok, world_pid, user_pid) do
    World.Process.user_enter(world_pid, user_pid)
  end

  #==============

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def start_all(), do: GenServer.call(__MODULE__, :start_all)
  def create(key), do: GenServer.call(__MODULE__, {:create, key})
  def user_enter(key), do: GenServer.call(__MODULE__, {:user_enter, key})
  def user_exit(world_pid), do: GenServer.call(__MODULE__, {:user_exit, world_pid})
  def user_message(world_pid, message), do: GenServer.call(__MODULE__, {:user_message, world_pid, message})
end

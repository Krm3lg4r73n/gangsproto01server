alias GangsServer.{User, Message, Util}

defmodule User.Manager do
  use GenServer

  def init(:ok) do
    refs = MapSet.new
    {:ok, refs}
  end

  def handle_call({:connect, _conn_pid}, _, refs) do
    # do nothing -> wait for Message.User
    {:reply, :ok, refs}
  end

  def handle_call({:disconnect, conn_pid}, _, refs) do
    case User.ConnectionRegistry.translate_key(conn_pid) do
      {:ok, user_pid} ->
        User.Process.disconnect(user_pid)
        Process.exit(user_pid, :disconnect)
      :error -> nil
    end
    {:reply, :ok, refs}
  end

  def handle_call({:message, conn_pid, %Message.User{name: name}}, _, refs) do
    case User.Policy.Auth.verify(name) do
      {:ok, user} -> process_conn(conn_pid, user)
      :error -> Util.send_conn_error(conn_pid, "Unknown")
    end
    {:reply, :ok, refs}
  end
  def handle_call({:message, conn_pid, %Message.ServerReset{}}, _, refs) do
    User.ConnectionRegistry.keys()
    |> Enum.filter(fn elem -> elem != conn_pid end)
    |> Enum.each(&Process.exit(&1, :reset))
    {:reply, :ok, refs}
  end
  def handle_call({:message, conn_pid, message}, _, refs) do
    case User.ConnectionRegistry.translate_key(conn_pid) do
      {:ok, user_pid} -> User.Process.message(user_pid, message)
      :error -> nil
    end
    {:reply, :ok, refs}
  end

  defp process_conn(conn_pid, user) do
    case User.UserRegistry.test_key(user.id) do
      :ok -> attach_user(conn_pid, user)
      :error -> Util.send_conn_error(conn_pid, "Already attached")
    end
  end

  defp attach_user(conn_pid, user) do
    {:ok, user_pid} = Supervisor.start_child(
                      User.Process.Supervisor,
                      [user])
    :ok = User.ConnectionRegistry.register(conn_pid, user_pid)
    :ok = User.UserRegistry.register(user.id, conn_pid)
    Util.send_conn_ok(conn_pid)
  end

  #==============

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def connect(conn_pid), do: GenServer.call(__MODULE__, {:connect, conn_pid})
  def disconnect(conn_pid), do: GenServer.call(__MODULE__, {:disconnect, conn_pid})
  def message(conn_pid, message), do: GenServer.call(__MODULE__, {:message, conn_pid, message})
end

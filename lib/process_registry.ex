defmodule ProcessRegistry do
  use GenServer

  def init(:ok) do
    registry = SymmetricMap.new
    {:ok, registry}
  end

  def handle_call({:test_key, key}, _from, registry) do
    case SymmetricMap.has_key?(registry, key) do
      true -> {:reply, :error, registry}
      false -> {:reply, :ok, registry}
    end
  end

  def handle_call({:register, key, pid}, _from, registry) do
    case SymmetricMap.put(registry, key, pid) do
      :error -> {:reply, :error, registry}
      {:ok, registry} ->
        Process.monitor(pid)
        {:reply, :ok, registry}
    end
  end

  def handle_call({:unregister_by_key, key}, _from, registry) do
    case SymmetricMap.delete_by_key(registry, key) do
      {:ok, registry} -> {:reply, :ok, registry}
      :error -> {:reply, :error, registry}
    end
  end

  def handle_call({:unregister_by_pid, pid}, _from, registry) do
    case SymmetricMap.delete_by_value(registry, pid) do
      {:ok, registry} -> {:reply, :ok, registry}
      :error -> {:reply, :error, registry}
    end
  end

  def handle_call({:translate_key, key}, _from, registry) do
    {:reply, SymmetricMap.fetch_by_key(registry, key), registry}
  end

  def handle_call({:translate_pid, pid}, _from, registry) do
    {:reply, SymmetricMap.fetch_by_value(registry, pid), registry}
  end

  def handle_info({:DOWN, _ref, _type, pid, _reason}, registry) do
    {:ok, registry} = SymmetricMap.delete_by_value(registry, pid)
    {:noreply, registry}
  end


  #==============

  defmacro __using__(_) do
    quote do
      def start_link(opts \\ []) do
        GenServer.start_link(ProcessRegistry, :ok, opts)
      end

      def test_key(key) do
        GenServer.call(__MODULE__, {:test_key, key})
      end

      def register(key, pid) do
        GenServer.call(__MODULE__, {:register, key, pid})
      end

      def unregister_by_key(key) do
        GenServer.call(__MODULE__, {:unregister_by_key, key})
      end

      def unregister_by_pid(pid) do
        GenServer.call(__MODULE__, {:unregister_by_pid, pid})
      end

      def translate_key(key) do
        GenServer.call(__MODULE__, {:translate_key, key})
      end

      def translate_pid(pid) do
        GenServer.call(__MODULE__, {:translate_pid, pid})
      end
    end
  end
end

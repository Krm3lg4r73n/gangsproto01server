defmodule StateLookup do
  use GenServer

  def init(:ok) do
    {:ok, Map.new()}
  end

  def handle_call({:put, entry, key, value}, _from, table) do
    case Map.fetch(table, entry) do
      {:ok, state} -> {:reply, :ok,
        Map.put(table, entry, Map.put(state, key, value))}
      :error -> {:reply, :ok,
        Map.put(table, entry, %{key => value})}
    end
  end

  def handle_call({:drop, entry}, _from, table) do
    {:reply, :ok, Map.drop(table, [entry])}
  end

  def handle_call({:lookup, entry}, _from, table) do
    {:reply, Map.get(table, entry), table}
  end

  # ==============

  defmacro __using__(_) do
    quote do
      def start_link(opts \\ []), do: GenServer.start_link(StateLookup, :ok, opts)
      def put(entry, key, value), do: GenServer.call(__MODULE__, {:put, entry, key, value})
      def drop(entry), do: GenServer.call(__MODULE__, {:drop, entry})
      def lookup(entry), do: GenServer.call(__MODULE__, {:lookup, entry})
    end
  end
end

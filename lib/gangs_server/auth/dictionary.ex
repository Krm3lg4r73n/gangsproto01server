require Logger
alias GangsServer.Auth

defmodule Auth.Dictionary do
  use GenServer

  def init(:ok) do
    dictionary = %{}
    {:ok, dictionary}
  end

  def handle_call({:add, conn, user}, _from, dictionary) do
    case Map.has_key?(dictionary, conn) do
      false ->
        dictionary = Map.put(dictionary, conn, user)
        {:reply, :ok, dictionary}
      true ->
        {:reply, :error, dictionary}
    end
  end

  def handle_call({:remove, conn}, _from, dictionary) do
    dictionary = Map.delete(dictionary, conn)
    {:reply, :ok, dictionary}
  end

  def handle_call({:translate, conn}, _from, dictionary) do
    {:reply, Map.fetch(dictionary, conn), dictionary}
  end

  #==============

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def add(conn, user) do
    GenServer.call(__MODULE__, {:add, conn, user})
  end

  def remove(conn) do
    GenServer.call(__MODULE__, {:remove, conn})
  end

  def translate(conn) do
    GenServer.call(__MODULE__, {:translate, conn})
  end
end

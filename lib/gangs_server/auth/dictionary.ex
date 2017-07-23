require Logger
alias GangsServer.Auth

defmodule Auth.Dictionary do
  use GenServer

  def init(:ok) do
    conn_to_user = %{}
    user_to_conn = %{}
    {:ok, {conn_to_user, user_to_conn}}
  end

  def handle_call({:add, conn, user}, _from, {conn_to_user, user_to_conn}) do
    if Map.has_key?(user_to_conn, user) ||
       Map.has_key?(conn_to_user, conn) do
      {:reply, :error, {conn_to_user, user_to_conn}}
    else
      conn_to_user = Map.put(conn_to_user, conn, user)
      user_to_conn = Map.put(user_to_conn, user, conn)
      {:reply, :ok, {conn_to_user, user_to_conn}}
    end
  end

  def handle_call({:remove, conn}, _from, {conn_to_user, user_to_conn}) do
    {user, conn_to_user} = Map.pop(conn_to_user, conn)
    user_to_conn = Map.delete(user_to_conn, user)
    {:reply, :ok, {conn_to_user, user_to_conn}}
  end

  def handle_call({:translate_conn, conn}, _from, {conn_to_user, user_to_conn}) do
    {:reply, Map.fetch(conn_to_user, conn), {conn_to_user, user_to_conn}}
  end

  def handle_call({:translate_user, user}, _from, {conn_to_user, user_to_conn}) do
    {:reply, Map.fetch(user_to_conn, user), {conn_to_user, user_to_conn}}
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

  def translate_conn(conn) do
    GenServer.call(__MODULE__, {:translate_conn, conn})
  end

  def translate_user(user) do
    GenServer.call(__MODULE__, {:translate_user, user})
  end
end

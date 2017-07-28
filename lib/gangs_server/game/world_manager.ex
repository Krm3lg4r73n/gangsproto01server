require Logger
alias GangsServer.Game

defmodule Game.WorldManager do
  use GenServer

  def handle_call({:create_world, key}, user_pid, _state) do
    Logger.info "#{inspect(user_pid)} creating world #{key}"
    {:reply, :ok, nil}
  end

  def handle_call({:join_world, key}, user_pid, _state) do
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

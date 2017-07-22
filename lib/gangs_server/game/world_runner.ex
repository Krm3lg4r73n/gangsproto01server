require Logger
alias GangsServer.Game

defmodule Game.WorldRunner do
  use GenServer

  def handle_call({:create_world}, _from, _state) do
    Logger.info "creating world"
    {:reply, :ok, nil}
  end

  #==============

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def create_world do
    GenServer.call(__MODULE__, {:create_world})
  end
end

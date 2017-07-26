alias GangsServer.{User, Message}

defmodule User.Process do
  use GenServer

  defstruct user: nil, super_user: false

  def init(user) do
    {:ok, user}
  end

  def handle_call({:set_locale, locale}, _from, user) do
    IO.inspect locale, user
    {:reply, :ok, user}
  end

  #==============

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def set_locale(pid, locale) do
    GenServer.call(pid, {:set_locale, locale})
  end

  def disconnect(_), do: nil

  def handle_message(_, _), do: nil
end

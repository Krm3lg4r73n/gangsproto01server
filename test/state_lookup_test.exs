defmodule TestDummy do
  use StateLookup
end

defmodule StateLookupTest do
  use ExUnit.Case, async: true

  alias TestDummy, as: Subject

  test "it can be started" do
    {:ok, pid} = Subject.start_link()
    assert Process.alive?(pid)
  end

  test "it starts empty" do
    {:ok, _} = Subject.start_link([name: Subject])
    {:ok, pid} = Agent.start_link(fn -> :ok end)
    assert Subject.lookup(pid) == nil
  end

  test "it can put new values" do
    {:ok, _} = Subject.start_link([name: Subject])
    {:ok, pid} = Agent.start_link(fn -> :ok end)
    assert Subject.put(pid, :key, :value) == :ok
    assert Subject.put(pid, :other_key, :other_value) == :ok
    assert Subject.lookup(pid) == %{key: :value, other_key: :other_value}
  end

  test "it can update values" do
    {:ok, _} = Subject.start_link([name: Subject])
    {:ok, pid} = Agent.start_link(fn -> :ok end)
    assert Subject.put(pid, :key, :value) == :ok
    assert Subject.put(pid, :key, :new_value) == :ok
    assert Subject.lookup(pid) == %{key: :new_value}
  end

  test "it can drop values" do
    {:ok, _} = Subject.start_link([name: Subject])
    {:ok, pid} = Agent.start_link(fn -> :ok end)
    assert Subject.put(pid, :key, :value) == :ok
    assert Subject.drop(pid) == :ok
    assert Subject.lookup(pid) == nil
  end
end

defmodule DummyRegistry do
  use ProcessRegistry
end

defmodule ProcessRegistryTest do
  use ExUnit.Case, async: true

  test "it can be started" do
    {:ok, _} = DummyRegistry.start_link()
  end

  test "it can register processes" do
    {:ok, pid} = DummyRegistry.start_link([name: DummyRegistry])
    assert DummyRegistry.register(:key, pid) == :ok
  end

  test "it can translate pids" do
    {:ok, pid} = DummyRegistry.start_link([name: DummyRegistry])
    :ok = DummyRegistry.register(:key, pid)
    assert DummyRegistry.translate_pid(pid) == {:ok, :key}
  end

  test "it can translate keys" do
    {:ok, pid} = DummyRegistry.start_link([name: DummyRegistry])
    :ok = DummyRegistry.register(:key, pid)
    assert DummyRegistry.translate_key(:key) == {:ok, pid}
  end

  test "it can unregister by pid" do
    {:ok, pid} = DummyRegistry.start_link([name: DummyRegistry])
    :ok = DummyRegistry.register(:key, pid)
    assert DummyRegistry.unregister_by_pid(pid) == :ok
    assert DummyRegistry.translate_pid(pid) == :error
  end

  test "it can unregister by key" do
    {:ok, pid} = DummyRegistry.start_link([name: DummyRegistry])
    :ok = DummyRegistry.register(:key, pid)
    assert DummyRegistry.unregister_by_key(:key) == :ok
    assert DummyRegistry.translate_key(:key) == :error
  end

  test "it cleans crashed processes" do
    {:ok, pid} = Agent.start(fn -> :ok end)
    {:ok, _} = DummyRegistry.start_link([name: DummyRegistry])
    :ok = DummyRegistry.register(:key, pid)

    assert DummyRegistry.translate_key(:key) == {:ok, pid}

    ref = Process.monitor(pid)
    Process.exit(pid, :shutdown)
    assert_receive {:DOWN, ^ref, :process, _, _}, 500

    assert DummyRegistry.translate_key(:key) == :error
  end

  test "it prevents duplicates" do
    {:ok, pid} = Agent.start(fn -> :ok end)
    {:ok, other_pid} = Agent.start(fn -> :ok end)
    {:ok, _} = DummyRegistry.start_link([name: DummyRegistry])
    :ok = DummyRegistry.register(:key, pid)
    assert DummyRegistry.register(:key, other_pid) == :error
    assert DummyRegistry.register(:other_key, pid) == :error
    assert DummyRegistry.register(:other_key, other_pid) == :ok
  end

  test "it can test for a key" do
    {:ok, pid} = Agent.start(fn -> :ok end)
    {:ok, _} = DummyRegistry.start_link([name: DummyRegistry])
    assert DummyRegistry.test_key(:key) == :ok
    :ok = DummyRegistry.register(:key, pid)
    assert DummyRegistry.test_key(:key) == :error
  end
end

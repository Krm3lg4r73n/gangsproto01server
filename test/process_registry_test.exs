defmodule TestRegistry do
  use ProcessRegistry
end

defmodule ProcessRegistryTest do
  use ExUnit.Case, async: true

  test "it can be started" do
    {:ok, _} = TestRegistry.start_link()
  end

  test "it can register processes" do
    {:ok, pid} = TestRegistry.start_link([name: TestRegistry])
    assert TestRegistry.register(:key, pid) == :ok
  end

  test "it can translate pids" do
    {:ok, pid} = TestRegistry.start_link([name: TestRegistry])
    :ok = TestRegistry.register(:key, pid)
    assert TestRegistry.translate_pid(pid) == {:ok, :key}
  end

  test "it can translate keys" do
    {:ok, pid} = TestRegistry.start_link([name: TestRegistry])
    :ok = TestRegistry.register(:key, pid)
    assert TestRegistry.translate_key(:key) == {:ok, pid}
  end

  test "it can unregister by pid" do
    {:ok, pid} = TestRegistry.start_link([name: TestRegistry])
    :ok = TestRegistry.register(:key, pid)
    assert TestRegistry.unregister_by_pid(pid) == :ok
    assert TestRegistry.translate_pid(pid) == :error
  end

  test "it can unregister by key" do
    {:ok, pid} = TestRegistry.start_link([name: TestRegistry])
    :ok = TestRegistry.register(:key, pid)
    assert TestRegistry.unregister_by_key(:key) == :ok
    assert TestRegistry.translate_key(:key) == :error
  end

  test "it cleans crashed processes" do
    {:ok, pid} = Agent.start(fn -> :ok end)
    {:ok, _} = TestRegistry.start_link([name: TestRegistry])
    :ok = TestRegistry.register(:key, pid)

    assert TestRegistry.translate_key(:key) == {:ok, pid}

    ref = Process.monitor(pid)
    Process.exit(pid, :shutdown)
    assert_receive {:DOWN, ^ref, :process, _, _}, 500

    assert TestRegistry.translate_key(:key) == :error
  end

  test "it prevents duplicates" do
    {:ok, pid} = Agent.start(fn -> :ok end)
    {:ok, other_pid} = Agent.start(fn -> :ok end)
    {:ok, _} = TestRegistry.start_link([name: TestRegistry])
    :ok = TestRegistry.register(:key, pid)
    assert TestRegistry.register(:key, other_pid) == :error
    assert TestRegistry.register(:other_key, pid) == :error
    assert TestRegistry.register(:other_key, other_pid) == :ok
  end

  test "it can test for a key" do
    {:ok, pid} = Agent.start(fn -> :ok end)
    {:ok, _} = TestRegistry.start_link([name: TestRegistry])
    assert TestRegistry.test_key(:key) == :ok
    :ok = TestRegistry.register(:key, pid)
    assert TestRegistry.test_key(:key) == :error
  end

  test "it lists all keys" do
    {:ok, pid} = Agent.start(fn -> :ok end)
    {:ok, other_pid} = Agent.start(fn -> :ok end)
    {:ok, _} = TestRegistry.start_link([name: TestRegistry])
    :ok = TestRegistry.register(:key, pid)
    :ok = TestRegistry.register(:other_key, other_pid)
    assert TestRegistry.keys == [:key, :other_key]
  end
end

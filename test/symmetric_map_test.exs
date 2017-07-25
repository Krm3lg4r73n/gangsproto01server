defmodule SymmetricMapTest do
  use ExUnit.Case, async: true

  test "it can put values" do
    subject = SymmetricMap.new
    assert {:ok, _} = SymmetricMap.put(subject, :key, :value)
  end

  test "it can fetch by keys" do
    subject = SymmetricMap.new
    {:ok, subject} = SymmetricMap.put(subject, :key, :value)
    assert SymmetricMap.fetch_by_key(subject, :key) == {:ok, :value}
  end

  test "it does not allow duplicate keys" do
    subject = SymmetricMap.new
    {:ok, subject} = SymmetricMap.put(subject, :key, :value)
    assert SymmetricMap.put(subject, :key, :other_value) == :error
  end

  test "it does not allow duplicate values" do
    subject = SymmetricMap.new
    {:ok, subject} = SymmetricMap.put(subject, :key, :value)
    assert SymmetricMap.put(subject, :other_key, :value) == :error
  end

  test "it can delete by keys" do
    subject = SymmetricMap.new
    {:ok, subject} = SymmetricMap.put(subject, :key, :value)
    {:ok, subject} = SymmetricMap.delete_by_key(subject, :key)
    assert SymmetricMap.delete_by_key(subject, :key) == :error
  end

  test "it can delete by values" do
    subject = SymmetricMap.new
    {:ok, subject} = SymmetricMap.put(subject, :key, :value)
    {:ok, subject} = SymmetricMap.delete_by_value(subject, :value)
    assert SymmetricMap.delete_by_value(subject, :value) == :error
  end
end

defmodule SymmetricMap do
  defstruct [:key_map, :value_map]

  def new do
    %SymmetricMap{key_map: Map.new, value_map: Map.new}
  end

  def put(%SymmetricMap{key_map: key_map, value_map: value_map}, key, value) do
    if Map.has_key?(key_map, key) ||
       Map.has_key?(value_map, value) do
      :error
    else
      {:ok, %SymmetricMap{key_map: Map.put(key_map, key, value),
                          value_map: Map.put(value_map, value, key)}}
    end
  end

  def delete_by_key(%SymmetricMap{key_map: key_map, value_map: value_map}, key) do
    case Map.fetch(key_map, key) do
      :error -> :error
      {:ok, value} ->
        case Map.has_key?(value_map, value) do
          true -> {:ok, %SymmetricMap{key_map: Map.delete(key_map, key),
                                     value_map: Map.delete(value_map, value)}}
          false -> :error
        end
    end
  end

  def delete_by_value(%SymmetricMap{key_map: key_map, value_map: value_map}, value) do
    reverse_map = %SymmetricMap{key_map: value_map, value_map: key_map}
    SymmetricMap.delete_by_key(reverse_map, value)
  end

  def fetch_by_key(%SymmetricMap{key_map: key_map}, key) do
    Map.fetch(key_map, key)
  end

  def fetch_by_value(%SymmetricMap{value_map: value_map}, value) do
    Map.fetch(value_map, value)
  end

  def has_key?(%SymmetricMap{key_map: key_map}, key) do
    Map.has_key?(key_map, key)
  end

  def has_value?(%SymmetricMap{value_map: value_map}, value) do
    Map.has_key?(value_map, value)
  end
end

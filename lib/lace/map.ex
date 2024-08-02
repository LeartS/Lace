defmodule Lace.Map do
  @moduledoc """
  Extra sweets for `Map`s
  """

  @doc """
  Moves the entry under `old_key` to `new_key`.
  If there was a prexisting value under `new_key`, it gets overwritten.
  If `old_key` is missing from the map, the map is returned unchanged.

  ## Examples

      iex> Lace.Map.move(%{name: "Marie Curie", field: "Physics"}, :name, :full_name)
      %{full_name: "Marie Curie", field: "Physics"}

      iex> Lace.Map.move(%{1 => "desert", 2 => "lake"}, 2, 1)
      %{1 => "lake"}

      iex> Lace.Map.move(%{}, "status", "state")
      %{}
  """
  @spec move(map(), Map.key(), Map.value()) :: map()
  def move(map, old_key, new_key) do
    case Map.has_key?(map, old_key) do
      false ->
        map

      true ->
        {value, map} = Map.pop(map, old_key)
        Map.put(map, new_key, value)
    end
  end

  @doc """
  Moves the value under `old_key` to `new_key`, unless `new_key` already exists in the map.
  Returns the map unchanged if `old_key` is missing.

  ## Examples

      iex> Lace.Map.move_new(%{secondary: 20}, :secondary, :primary)
      %{primary: 20}

      iex> Lace.Map.move_new(%{primary: 10, secondary: 20}, :secondary, :primary)
      %{primary: 10, secondary: 20}
  """
  @spec move(map(), Map.key(), Map.value()) :: map()
  def move_new(map, old_key, new_key) do
    case Map.has_key?(map, new_key) do
      true -> map
      false -> move(map, old_key, new_key)
    end
  end
end

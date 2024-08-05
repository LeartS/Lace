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
  @spec move_new(map(), Map.key(), Map.value()) :: map()
  def move_new(map, old_key, new_key) do
    case Map.has_key?(map, new_key) do
      true -> map
      false -> move(map, old_key, new_key)
    end
  end

  @doc """
  Puts the given `value` in `map` under `key` if `value` is non-`nil`.

  Useful to conditionally add non-empty fields to maps,
  in a pipeline-friendly way and without having to do a second pass
  to reject fields with empty values.

  If you need custom logic to decide whether to add the value,
  use `put_if/4`, which takes a predicate function.

  ## Example

      iex> fetch_user = fn _user_id -> nil end
      ...> fetch_project = fn project_id -> "project-" <> to_string(project_id) end
      ...>
      ...> %{}
      ...> |> Lace.Map.put_if(:user, fetch_user.(23))
      ...> |> Lace.Map.put_if(:project, fetch_project.(13))
      %{project: "project-13"}
  """
  def put_if(map, key, value) do
    case value do
      nil -> map
      _ -> Map.put(map, key, value)
    end
  end

  @doc """
  Conditionally adds a value to the map based on a predicate function.

  This function is similar to `put_if`, but allows for more complex
  logic by using a predicate function that takes two parameters: the
  current map and the value to be added. The predicate should return
  a boolean indicating whether the value should be inserted into the map.

  ## Examples

      iex> Lace.Map.put_if(%{a: 1}, :b, 2 + 3, fn _map, n -> n > 4 end)
      %{a: 1, b: 5}

      iex> Lace.Map.put_if(%{a: 1}, :b, 2, fn _, _ -> :rand.uniform(3) < 5 end)
      %{a: 1, b: 2}

      iex> Lace.Map.put_if(%{a: 1}, :b, 2, fn _, _ -> :rand.uniform(3) > 5 end)
      %{a: 1}
  """
  @spec put_if(map(), Map.key(), Map.value(), (map(), Map.value() -> boolean())) :: map()
  def put_if(map, key, value, predicate_fn) do
    case predicate_fn.(map, value) do
      false -> map
      true -> Map.put(map, key, value)
    end
  end
end

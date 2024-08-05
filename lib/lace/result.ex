defmodule Lace.Result do
  @moduledoc """
  A module for working with result tuples in a clear, composable, and pipeline-friendly manner.

  ## Result Representation

  This module defines `t:result/0` as strictly `{:ok, any()} | {:error, any()}`,
  and the majority of functions within this module operate exclusively on these values.

  Several standard library functions and various packages in the Elixir ecosystem
  return values such as `:ok`, `{:ok, val, extra_info}`, `:error`, and `{:error, code, extra_info}`,
  along with other result-like but inconsistently structured values.
  We refer to these values as _okish_ (representing successful computations)
  and _errorish_ (indicating failures), collectively termed _resultish_.

  You can use `from/1` to convert this diverse array of values into consistent `t:result/0` types,
  enabling you to leverage the utilities provided by this module.

  ## Best Practices for Error Values

  For error handling, we advocate for the best practice of using `{:error, <exception struct>}`,
  particularly in libraries and packages intended for use by other code.

  One of the first public mentions of this approach can be found in a post on Michał Muskała's blog,
  with a  from Andrea Leopardi (@whatyouhide, now a member of the Elixir Core Team)
  https://web.archive.org/web/20180414015950/http://michal.muskala.eu/2017/02/10/error-handling-in-elixir-libraries.html#comments-whatyouhide-errors

  This pattern is adopted by several high-profile and well-architected libraries,
  including Redix, Mint, Req, among others.
  It offers several advantages including: a consistent shape for pattern matching,
  being able to trivially raise exceptions or extract messages from error tuples,
  and the ability to include additional fields with details in the error value.
  """
  @type ok(v) :: {:ok, v}
  @type error(e) :: {:error, e}
  @typedoc """

  """
  @type result(v, e) :: ok(v) | error(e)
  @type okish() ::
          :ok
          | {:ok, any()}
          | {:ok, any(), any()}
          | {:ok, any(), any(), any()}
          | {:ok, any(), any(), any(), any()}
          | {:ok, any(), any(), any(), any(), any()}
  @type errorish() ::
          :error
          | Exception.t()
          | {:error, any()}
          | {:error, any(), any()}
          | {:error, any(), any(), any()}
          | {:error, any(), any(), any(), any()}
          | {:error, any(), any(), any(), any(), any()}

  @doc """
  Returns `true` if `val` is _errorish_ (including a well-formed error value).
  Such values would be converted into an `{:error, _}` tuple by the `from/1` function.
  Can be used in guard tests.
  """
  defguard is_errorish(val)
           when val == :error or
                  is_exception(val) or
                  (is_tuple(val) and elem(val, 0) == :error)

  @doc """
  Returns `true` if `val` is _okish_ (including a well-formed ok value).
  Such values would be converted into an `{:ok, _}` tuple by the `from/1` function.
  Can be used in guard tests.
  """
  defguard is_okish(val)
           when val == :ok or
                  (is_tuple(val) and elem(val, 0) == :ok)

  @doc """
  Returns `true` if `val` is neither _okish_ nor _errorish_.
  Such values would be converted into an `{:ok, _}` tuple by the `from/` function.
  Can be used in guard tests.
  """
  defguard is_valish(val) when not (is_errorish(val) or is_okish(val))

  @doc """
  Tries its best to transform any value into a well-formed `t:result` tuple,
  of the kind handled by the functions in this module.
  It does so by based on the value's _resultishness_: _errorish_ values are converted
  to `t:error/0`s, while any other value is converted to `t:ok/0`.

  Useful to transform _resultish_ values into proper result values,
  which can then be used in chainable and linear `Lace.Result` pipelines.

  ## Examples:

      iex> from(12)
      {:ok, 12}

      iex> from(:ok)
      {:ok, nil}

      iex> from(:error)
      {:error, nil}

      iex> from({:ok, 12})
      {:ok, 12}

      iex> from({:error, :reason, %{trace_id: 100}})
      {:error, {:reason, %{trace_id: 100}}}

      iex> from(RuntimeError.exception("oh-oh!"))
      {:error, %RuntimeError{message: "oh-oh!"}}
  """
  def from(:ok), do: {:ok, nil}
  def from({:ok, value}), do: {:ok, value}
  def from({:ok, v1, v2}), do: {:ok, {v1, v2}}
  def from({:ok, v1, v2, v3}), do: {:ok, {v1, v2, v3}}
  def from({:ok, v1, v2, v3, v4}), do: {:ok, {v1, v2, v3, v4}}
  def from({:ok, v1, v2, v3, v4, v5}), do: {:ok, {v1, v2, v3, v4, v5}}
  def from(:error), do: {:error, nil}
  def from({:error, err}), do: {:error, err}
  def from({:error, a, b}), do: {:error, {a, b}}
  def from({:error, a, b, c}), do: {:error, {a, b, c}}
  def from({:error, a, b, c, d}), do: {:error, {a, b, c, d}}
  def from({:error, a, b, c, d, e}), do: {:error, {a, b, c, d, e}}
  def from(err) when is_exception(err), do: {:error, err}
  def from(val), do: {:ok, val}

  @doc """
  Turns a value into an ok `t:result()` by wrapping it in an `{:ok, ...}` tuple.

  Note that this always returns an :ok tuple, it does not try to infer the most
  appropriate result type. Use `from/1` for that.

  ## Examples

      iex> 2 |> ok()
      {:ok, 2}

      iex> {:error, :http_error} |> ok()
      {:ok, {:error, :http_error}}
  """
  @spec ok(v) :: result(v, none()) when v: var
  def ok(val), do: {:ok, val}

  @doc """
  Turns a value into an error `t:result()` by wrapping it in an `{:error, ...}` tuple.

  Note that this always returns an :error tuple, it does not try to infer the most
  appropriate result type. Use `from/1` for that.

  ## Examples

      iex> :http_error |> error()
      {:error, :http_error}

      iex> {:ok, 12} |> error()
      {:error, {:ok, 12}}
  """
  @spec error(e) :: result(none(), e) when e: var
  def error(err), do: {:error, err}

  @doc """
  Collect a list of results into a tuple of ok values and errors.

  ## Examples

      iex> Lace.Result.collect([{:ok, 1}, {:error, 2}, {:ok, 3}])
      {[1, 3], [2]}

      iex> Lace.Result.collect([{:ok, "green"}])
      {["green"], []}
  """
  @spec collect([result(v, e)]) :: {[v], [e]} when v: var, e: var
  def collect(results) do
    {oks, errs} =
      Enum.reduce(results, {[], []}, fn res, {oks, errs} ->
        case res do
          {:ok, val} -> {[val | oks], errs}
          {:error, err} -> {oks, [err | errs]}
        end
      end)

    {:lists.reverse(oks), :lists.reverse(errs)}
  end

  @doc """
  Collapses a list of results into a single result.

  Stops at the first error encountered.

  ## Examples

      iex> Lace.Result.collapse([{:ok, 1}, {:ok, 2}, {:ok, 3}])
      {:ok, [1, 2, 3]}

      iex> Lace.Result.collapse([{:ok, 1}, {:error, 2}, {:ok, 3}, {:error, 4}])
      {:error, 2}
  """
  def collapse(results) do
    results
    |> Enum.reduce_while(
      [],
      fn
        {:ok, val}, values -> {:cont, [val | values]}
        {:error, err}, _acc -> {:halt, {:error, err}}
      end
    )
    |> case do
      {:error, err} -> {:error, err}
      ok_values when is_list(ok_values) -> {:ok, Enum.reverse(ok_values)}
    end
  end

  @doc """
  Chains a result with a function that returns a new result.

  If the initial result is `{:ok, value}`, the provided function is called with the value,
  and its result is returned. If the initial result is `{:error, error}`, the error is returned
  without calling the function.

  Great for building lazy pipelines of fallible computations.

  ## Examples

      iex> chain({:ok, 1}, fn x -> {:ok, x + 1} end)
      {:ok, 2}

      iex> chain({:error, "missing number"}, fn x -> {:ok, x + 1} end)
      {:error, "missing number"}

      iex> {:ok, 1}
      ...> |> chain(fn x -> {:ok, x + 1} end)
      ...> |> chain(fn x -> {:ok, x * 2} end)
      ...> |> chain(fn x -> {:error, :nan} end)
      ...> |> chain(fn x -> {:ok, x * 10} end)
      {:error, :nan}
  """
  @spec chain(result(v1, e1), (v1 -> result(v2, e2))) :: result(v2, e1 | e2)
        when v1: var, v2: var, e1: var, e2: var
  def chain(result, next_fn)

  def chain({:ok, val}, next_fn), do: next_fn.(val)
  def chain({:error, err}, _next_fn), do: {:error, err}
end

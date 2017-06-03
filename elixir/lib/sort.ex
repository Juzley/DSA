defmodule Sort do
  @moduledoc """
  Various sorting algorithms.
  """

###############################################################################
# Quicksort
###############################################################################

  # Partition the list around the pivot
  defp partition([], _pivot, _cmp, left, right), do: {left, right}
  defp partition([head | rem], pivot, cmp, left, right) do
    if cmp.(head, pivot) do
      partition(rem, pivot, cmp, [head | left], right)
    else
      partition(rem, pivot, cmp, left, [head | right])
    end
  end
  defp partition(list, pivot, cmp), do: partition(list, pivot, cmp, [], [])


  @ doc """
  Quicksort.

  ## Example

    iex> Sort.quick([3, 1, 2])
    [1, 2, 3]
    iex> Sort.quick(["aaa", "a", "aa"],
    ...> &(String.length(&1) <= String.length(&2)))
    ["a", "aa", "aaa"]
  """
  def quick(list, cmp \\ &(&1 <= &2))
  def quick([], _cmp), do: []
  def quick([elem], _cmp), do: [elem]
  def quick([pivot | rem], cmp) do
    # Note that we pick the first element as the pivot, just because that's
    # easiest with the cons notation.
    {left, right} = partition(rem, pivot, cmp)
    quick(left, cmp) ++ [pivot] ++ quick(right, cmp)
  end


###############################################################################
# Merge Sort
###############################################################################

  # Finished merging, return the result of the merge.
  defp _merge([], [], _cmp, result) do
    Enum.reverse(result)
  end

  # Exhausted the RHS of the merge, add the head of the LHS.
  defp _merge([lhead | lrem], [], cmp, result) do
    _merge(lrem, [], cmp, [lhead | result])
  end
   
  # Exhausted the LHS of the merge, add the head of the RHS.
  defp _merge([], [rhead | rrem], cmp, result) do
    _merge([], rrem, cmp, [rhead | result])
  end

  # Mainline merge - pick the smaller of the LHS and RHS heads.
  defp _merge(left=[lhead | lrem], right=[rhead | rrem], cmp, result) do
    if cmp.(lhead, rhead) do
      _merge(lrem, right, cmp, [lhead | result])
    else
      _merge(left, rrem, cmp, [rhead | result])
    end
  end

  @doc """
  Merge sort.

  ## Example

    iex> Sort.merge([3, 1, 2])
    [1, 2, 3]
    iex> Sort.merge(["aaa", "a", "aa"],
    ...> &(String.length(&1) <= String.length(&2)))
    ["a", "aa", "aaa"]
  """
  def merge(list, cmp \\ &(&1 <= &2))
  def merge([], _cmp), do: []
  def merge([elem], _cmp), do: [elem]
  def merge(list, cmp) do
    {left, right} = Enum.split(list, div(Enum.count(list), 2))
    _merge(merge(left, cmp), merge(right, cmp), cmp, [])
  end
end

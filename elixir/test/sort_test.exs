defmodule SortTest do
  use ExUnit.Case

  def strlen_cmp(a, b), do: String.length(a) <= String.length(b)

  test "merge sort" do
    assert Sort.merge([]) == Enum.sort([])
    assert Sort.merge([1]) == Enum.sort([1])
    assert Sort.merge([1, 1]) == Enum.sort([1, 1])
    assert Sort.merge([1, 2, 3]) == Enum.sort([1, 2, 3])
    assert Sort.merge([3, 2, 1]) == Enum.sort([3, 2, 1])
    assert Sort.merge([3, 1, 5, 4, 2, 6]) == Enum.sort([3, 1, 5, 4, 2, 6])
    assert Sort.merge(["aa", "a", "aaa"], &strlen_cmp/2) ==
           Enum.sort(["aa", "a", "aaa"], &strlen_cmp/2)
  end

  test "quick sort" do
    assert Sort.quick([]) == Enum.sort([])
    assert Sort.quick([1]) == Enum.sort([1])
    assert Sort.quick([1, 1]) == Enum.sort([1, 1])
    assert Sort.quick([1, 2, 3]) == Enum.sort([1, 2, 3])
    assert Sort.quick([3, 2, 1]) == Enum.sort([3, 2, 1])
    assert Sort.quick([3, 1, 5, 4, 2, 6]) == Enum.sort([3, 1, 5, 4, 2, 6])
    assert Sort.quick(["aa", "a", "aaa"], &strlen_cmp/2) ==
           Enum.sort(["aa", "a", "aaa"], &strlen_cmp/2)
   end

   doctest Sort
end
    

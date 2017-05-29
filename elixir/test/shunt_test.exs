defmodule ShuntingYardTest do
  use ExUnit.Case

  import DSA.ShuntingYard

  test "Simple binary operations" do
    assert shunt("1 + 2") == "1 2 +"
    assert shunt("2 - 1") == "2 1 -"
    assert shunt("2 * 3") == "2 3 *"
    assert shunt("4 / 2") == "4 2 /"
  end

  test "Operator precedence" do
    assert shunt("1 + 2 - 3") == "1 2 + 3 -"
    assert shunt("1 - 2 + 3") == "1 2 - 3 +"
    assert shunt("1 * 2 / 3") == "1 2 * 3 /"
    assert shunt("1 / 2 * 3") == "1 2 / 3 *"
    assert shunt("1 + 2 * 3") == "1 2 3 * +"
    assert shunt("1 * 2 + 3") == "1 2 * 3 +"
    assert shunt("1 + 2 / 3") == "1 2 3 / +"
    assert shunt("1 / 2 + 3") == "1 2 / 3 +"
    assert shunt("1 - 2 * 3") == "1 2 3 * -"
    assert shunt("1 * 2 - 3") == "1 2 * 3 -"
    assert shunt("1 - 2 / 3") == "1 2 3 / -"
    assert shunt("1 / 2 - 3") == "1 2 / 3 -"
  end

  test "Parentheses" do
    assert shunt("(1 + 2) * 3") == "1 2 + 3 *"
    assert shunt("1 + (2 * 3)") == "1 2 3 * +"
    assert shunt("1 - ((2 + 3) / 4)") == "1 2 3 + 4 / -"
  end

  doctest DSA.ShuntingYard
end

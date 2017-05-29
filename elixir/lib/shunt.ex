defmodule DSA.ShuntingYard do
  @moduledoc """
  Implementation of the shunting-yard algorithm for converting
  infix-notiation expressions to reverse-polish notation, as described
  at https://en.wikipedia.org/wiki/Shunting-yard_algorithm.

  This implementation only supports expressions containing numbers,
  parentheses and the +, -, * and / operators.
  """

  # The list of supported operators.
  @ops ['+', '-', '*', '/']

  # Maps each operator to a number representing its relative precedence.
  @op_precedence %{ '+' => 0, '-' => 0, '*' => 1, '/' => 1 }

  # Determine whether a given operator has precedence over another op.
  defp has_precedence(op, other) do
    # Note that all ops we support are left-associative, so we don't need to
    # check for associativity here.
    @op_precedence[other] <= @op_precedence[op]
  end

  # End of input, and the stack is empty - we're done.
  defp _shunt([], [], output), do: Enum.reverse(output)

  # End of input, but stack is non-empty - pop from the stack.
  defp _shunt([], [token | rem], output), do: _shunt([], rem, [token | output])

  # Next token is (, push it onto the stack.
  defp _shunt([token='(' | rem], stack, output) do
    _shunt(rem, [token | stack], output)
  end

  # Found the matching ( for a ), carry on processing the rest of the input.
  defp _shunt([')' | rem], ['(' | stack_rem], output) do
      _shunt(rem, stack_rem, output)
  end

  # Next token is ), pop from the stack to the output until we find
  # a matching (.
  defp _shunt(input=[')' | _], [stack_head | stack_rem], output) do
      _shunt(input, stack_rem, [stack_head | output])
  end

  # Next token is an operator, and the top of the stack is also an operator.
  # Need to compare the precedence of the operators.
  defp _shunt(input=[op1 | rem_input], stack=[op2 | rem_stack], output)
    when op1 in @ops and op2 in @ops do
    if has_precedence(op2, op1) do
      # Op2 has higher precedence, pop it off the stack and into the output.
      _shunt(input, rem_stack, [op2 | output])
    else
      # Op1 has higher precedence, push it onto the stack.
      _shunt(rem_input, [op1 | stack], output)
    end
  end
    
  # Next token is an operator, and the top of the stack isn't one. Push onto
  # the stack.
  defp _shunt([op | rem], stack, output) when op in @ops do
      _shunt(rem, [op | stack], output)
  end

  # Next token is a number, just add it to the output.
  defp _shunt([token | rem], stack, output) when is_number(token) do
      _shunt(rem, stack, [token | output])
  end

  # Convert a string containing a single term into an integer, float or
  # character list.
  defp convert_term(term) do
    cond do
      String.match?(term, ~r/\d+\.\d+/) -> elem(Float.parse(term), 0)
      String.match?(term, ~r/\d+/) -> elem(Integer.parse(term), 0)
      true -> String.to_charlist(term)
    end
  end

  # Split a string containing an expression into a list containing a string
  # for each term in the expression. For example "1 + 2" -> ["1", "+", "2"]
  defp split_expr(expr) do
    Regex.split(~r/(\d+\.\d+|\d+|[()-+*\/])/, expr,
                include_captures: true, trim: true)
  end

  # Parse a string containing an expression into a list containing numbers
  # or characters for operations. For example "1 + 2" -> [1, '+', 2]
  defp parse_expr(expr) do
    expr
    |> String.replace(" ", "")
    |> split_expr
    |> Enum.map(&convert_term/1)
  end

  # Converts a single entry in the output list into a string. For example
  # '+' -> "+" or 2.2 -> "2.2"
  defp format_output(term) when is_float(term), do: Float.to_string(term)
  defp format_output(term) when is_integer(term), do: Integer.to_string(term)
  defp format_output(term) when is_list(term), do: List.to_string(term)

  @doc """
  Convert an expression in infix notation to reverse-polish notation, using
  the Shunting Yard Algorithm.

  ## Parameters

    - expr: String containing the expression to be converted.

  ## Examples

      iex> DSA.ShuntingYard.shunt("1 - ((2 + 3) / 4)")
      "1 2 3 + 4 / -"
  """
  @spec shunt(String.t) :: String.t
  def shunt(expr) do
    expr
    |> parse_expr
    |> _shunt([], [])
    |> Enum.map(&format_output/1)
    |> Enum.join(" ")
  end
end

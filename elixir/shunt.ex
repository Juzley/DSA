defmodule ShuntingYard do
    defp _shunt([], []), do: []
    defp _shunt([], [token | rem]), do: [token] ++ _shunt([], rem)

    defp _shunt([')' | rem], ['(' | stack_rem]) do
        _shunt(rem, stack_rem)
    end

    defp _shunt(expr=[')' | _], [stack_head | stack_rem]) do
        [stack_head] ++ _shunt(expr, stack_rem)
    end

    defp _shunt([token | rem], stack) when token in ['(', '+', '-'] do
        _shunt(rem, [token] ++ stack)
    end

    defp _shunt([token | rem], stack) when is_integer(token) do
        [token] ++ _shunt(rem, stack)
    end

    def shunt(expr), do: _shunt(expr, [])
end

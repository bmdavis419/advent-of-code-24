defmodule DaySeven do
  def handle_input(input) do
    lines = String.split(input, "\n")

    Enum.map(lines, fn line ->
      [test, items] = String.split(line, ": ")

      {
        String.to_integer(test),
        String.split(items, " ")
        |> Enum.map(fn item ->
          String.to_integer(item)
        end)
      }
    end)
  end

  def handle_equation([first], _is_multiply), do: [first]

  def handle_equation([first | rest], is_multiply) do
    rec_total_multiply = handle_equation(rest, true)
    rec_total_add = handle_equation(rest, false)

    sub_items = rec_total_multiply ++ rec_total_add

    if is_multiply do
      Enum.map(sub_items, fn item ->
        item * first
      end)
    else
      Enum.map(sub_items, fn item ->
        item + first
      end)
    end
  end

  def check_found(_test, []), do: false

  def check_found(test, [item | _rest]) when test == item, do: true

  def check_found(test, [_item | rest]), do: check_found(test, rest)

  def main() do
    File.read!("input.txt")
    |> handle_input()
    |> Enum.map(fn {test, nums} ->
      num_reversed = Enum.reverse(nums)
      a_tests = handle_equation(num_reversed, false)
      m_tests = handle_equation(num_reversed, true)

      all_tests = a_tests ++ m_tests

      if check_found(test, all_tests) do
        test
      else
        0
      end
    end)
    |> Enum.sum()
    |> IO.inspect()
  end
end

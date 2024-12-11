defmodule DayEleven do
  def handle_input(input) do
    String.split(input, " ", trim: true)
    |> Enum.map(fn item ->
      String.to_integer(item)
    end)
  end

  def blink([]), do: []

  def blink([first | rest]) when first == 0, do: [1] ++ blink(rest)

  def blink([first | rest]) do
    first_string = Integer.to_string(first)
    first_string_length = String.length(first_string)

    if rem(first_string_length, 2) == 0 do
      half_length = div(first_string_length, 2)
      {first_half, second_half} = String.split_at(first_string, half_length)

      [String.to_integer(first_half), String.to_integer(second_half)] ++ blink(rest)
    else
      [first * 2024] ++ blink(rest)
    end
  end

  def blink_n_times(cur_state, idx, n) when idx == n, do: cur_state

  def blink_n_times(cur_state, idx, n), do: blink_n_times(blink(cur_state), idx + 1, n)

  def main() do
    File.read!("input.txt")
    |> handle_input()
    |> blink_n_times(0, 25)
    |> length()
    |> IO.inspect()
  end
end

defmodule DayEight do
  def handle_input(input) do
    String.split(input, "", trim: true)
    |> Enum.map(fn entry ->
      String.to_integer(entry)
    end)
  end

  def get_blocks(input) do
    Enum.with_index(input)
    |> Enum.reduce([], fn {value, idx}, acc ->
      append_value =
        if rem(idx, 2) == 0 do
          div(idx, 2)
        else
          -1
        end

      acc ++
        if value > 0 do
          for _ <- 1..value do
            append_value
          end
        else
          []
        end
    end)
  end

  # base case
  def shrink_blocks([], _rest), do: []

  def shrink_blocks([first_blocks | rest_blocks], [first_reverse_blocks | rest_reverse_blocks]) do
    if first_blocks >= 0 do
      [first_blocks] ++ shrink_blocks(rest_blocks, [first_reverse_blocks | rest_reverse_blocks])
    else
      if first_reverse_blocks == -1 do
        shrink_blocks([first_blocks | rest_blocks], rest_reverse_blocks)
      else
        [first_reverse_blocks] ++ shrink_blocks(rest_blocks, rest_reverse_blocks)
      end
    end
  end

  def main() do
    blocks = File.read!("input.txt") |> handle_input() |> get_blocks()

    num_blank =
      Enum.reduce(blocks, 0, fn block, acc ->
        if block == -1 do
          acc + 1
        else
          acc
        end
      end)

    shrunk_blocks = shrink_blocks(blocks, Enum.reverse(blocks)) |> Enum.drop(-num_blank)

    Enum.with_index(shrunk_blocks)
    |> Enum.map(fn {block, idx} -> block * idx end)
    |> Enum.sum()
    |> IO.inspect()
  end
end

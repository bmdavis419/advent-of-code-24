defmodule DayNineteen do
  def handle_input(input) do
    [designs, patterns] = String.split(input, "\n\n", trim: true)

    {
      String.split(designs, ", "),
      String.split(patterns, "\n")
    }
  end

  def check_design(_pattern_pieces, [], idx), do: {true, idx}

  def check_design([], _design_pieces, _idx), do: {false, 0}

  def check_design([first_pattern | rest_pattern], [first_design | rest_design], idx) do
    if first_design == first_pattern do
      check_design(rest_pattern, rest_design, idx + 1)
    else
      {false, 0}
    end
  end

  def try_designs(_pattern_pieces, []), do: {false, []}

  def try_designs(pattern_pieces, [design | rest_designs]) do
    design_pieces = String.split(design, "", trim: true)
    {valid, idx} = check_design(pattern_pieces, design_pieces, 0)

    if valid do
      {more_valid, more_pattern_cont} = try_designs(pattern_pieces, rest_designs)

      if more_valid do
        {true, more_pattern_cont ++ [Enum.drop(pattern_pieces, idx)]}
      else
        {true, [Enum.drop(pattern_pieces, idx)]}
      end
    else
      try_designs(pattern_pieces, rest_designs)
    end
  end

  def try_make_pattern([], _designs), do: true

  def try_make_pattern(pattern_pieces, designs) do
    {valid, rest} = try_designs(pattern_pieces, designs)

    if valid do
      Enum.reduce(rest, false, fn cur_rest, acc ->
        acc or try_make_pattern(cur_rest, designs)
      end)
    else
      false
    end
  end

  def main() do
    {designs, patterns} = File.read!("input.txt") |> handle_input()

    Enum.reduce(patterns, 0, fn pattern, acc ->
      pattern_pieces = String.split(pattern, "", trim: true)

      if try_make_pattern(pattern_pieces, designs) do
        acc + 1
      else
        acc
      end
    end)
    |> IO.inspect()
  end
end

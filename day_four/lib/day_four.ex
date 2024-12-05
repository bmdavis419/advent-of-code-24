# WORRY ABOUT RUNTIME LATER BOZO
defmodule DayFour do
  def search(_, x, _, _, bound_x, _, _, _) when x < 0 or x >= bound_x, do: 0
  def search(_, _, y, _, _, bound_y, _, _) when y < 0 or y >= bound_y, do: 0

  def search(grid, x, y, idx, bound_x, bound_y, x_dir, y_dir) do
    pattern = ["X", "M", "A", "S"]

    entry = Enum.at(grid, y) |> Enum.at(x)

    if entry == Enum.at(pattern, idx) do
      if entry == "S" do
        1
      else
        search(grid, x + x_dir, y + y_dir, idx + 1, bound_x, bound_y, x_dir, y_dir)
      end
    else
      0
    end
  end

  def search(grid, x, y, idx, bound_x, bound_y) do
    entry = Enum.at(grid, y) |> Enum.at(x)

    if entry == "X" do
      directions = [-1, 0, 1]

      Enum.reduce(directions, 0, fn x_dir, top_count ->
        Enum.reduce(directions, 0, fn y_dir, sub_count ->
          search(grid, x + x_dir, y + y_dir, idx + 1, bound_x, bound_y, x_dir, y_dir) + sub_count
        end) + top_count
      end)
    else
      0
    end
  end

  def convert_to_grid(input) do
    lines = String.split(input, "\n")
    num_lines = length(lines)

    grid =
      Enum.map(lines, fn line ->
        String.split(line, "", trim: true)
      end)

    {grid, length(Enum.at(grid, 0)), num_lines}
  end

  def main do
    {grid, bound_x, bound_y} =
      case File.read("input.txt") do
        {:ok, content} -> content
        {:error, reason} -> raise "failed to read file: #{reason}"
      end
      |> convert_to_grid()

    for {row, y} <- Enum.with_index(grid), {_, x} <- Enum.with_index(row) do
      search(grid, x, y, 0, bound_x, bound_y)
    end
    |> Enum.sum()
    |> IO.inspect()
  end
end

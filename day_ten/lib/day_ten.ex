defmodule DayTen do
  def handle_input(input) do
    String.split(input, "\n")
    |> Enum.map(fn row ->
      String.split(row, "", trim: true)
      |> Enum.map(fn entry ->
        String.to_integer(entry)
      end)
    end)
  end

  def find_paths(_grid, _idx, x_pos, _y_pos, x_bound, _y_bound) when x_pos > x_bound or x_pos < 0,
    do: []

  def find_paths(_grid, _idx, _x_pos, y_pos, _x_bound, y_bound) when y_pos > y_bound or y_pos < 0,
    do: []

  def find_paths(grid, idx, x_pos, y_pos, x_bound, y_bound) do
    # check if the current spot matches the idx
    cur_spot = grid |> Enum.at(y_pos) |> Enum.at(x_pos)

    if cur_spot == idx do
      if cur_spot == 9 do
        [{x_pos, y_pos}]
      else
        left =
          find_paths(grid, idx + 1, x_pos + -1, y_pos + 0, x_bound, y_bound)

        right =
          find_paths(grid, idx + 1, x_pos + 1, y_pos + 0, x_bound, y_bound)

        up =
          find_paths(grid, idx + 1, x_pos + 0, y_pos + 1, x_bound, y_bound)

        down =
          find_paths(grid, idx + 1, x_pos + 0, y_pos + -1, x_bound, y_bound)

        left ++ right ++ up ++ down
      end
    else
      []
    end
  end

  def trim_unique(coords) do
    Enum.reduce(coords, [], fn coord, acc ->
      if coord in acc do
        acc
      else
        acc ++ [coord]
      end
    end)
  end

  def process_grid(grid) do
    rows = length(grid)
    cols = length(List.first(grid))

    for y <- 0..(rows - 1),
        x <- 0..(cols - 1) do
      find_paths(grid, 0, x, y, cols - 1, rows - 1) |> trim_unique() |> length()
    end
    |> Enum.sum()
  end

  def main() do
    File.read!("input.txt") |> handle_input() |> process_grid() |> IO.inspect()
  end
end

defmodule DayTwelve do
  @directions [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]

  def search_group(_grid, x, _y, _entry, x_bound, _y_bound, searched_cords)
      when x > x_bound or x < 0,
      do: searched_cords

  def search_group(_grid, _x, y, _entry, _x_bound, y_bound, searched_cords)
      when y > y_bound or y < 0,
      do: searched_cords

  def search_group(grid, x, y, entry, x_bound, y_bound, searched_cords) do
    {search_cords, search_entry} = Enum.at(grid, y) |> Enum.at(x)

    IO.inspect(searched_cords)

    if Enum.member?(searched_cords, search_cords) do
      searched_cords
    else
      if search_entry == entry do
        Enum.reduce(@directions, [], fn {search_x, search_y}, acc ->
          acc ++
            search_group(
              grid,
              x + search_x,
              y + search_y,
              entry,
              x_bound,
              y_bound,
              [{x, y} | searched_cords]
            )
        end)
      else
        searched_cords
      end
    end
  end

  def make_group(grid, {cords, entry}, taken_spots, x_bound, y_bound) do
    if Enum.member?(taken_spots, cords) do
      {:taken, []}
    else
      {x, y} = cords
      {:found, search_group(grid, x, y, entry, x_bound, y_bound, [])}
    end
  end

  # desired form: {{x, y}, "X"}

  def handle_input(input) do
    String.split(input, "\n")
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      String.split(line, "", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {entry, x} ->
        {{x, y}, entry}
      end)
    end)
  end

  def main() do
    File.read!("input.txt")
    |> handle_input()
    |> make_group({{0, 0}, "A"}, [], 3, 3)
    |> IO.inspect()
  end
end

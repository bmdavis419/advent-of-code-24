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

  def remove_duplicates([], found), do: found

  def remove_duplicates([head | tail], found) do
    if Enum.member?(found, head) do
      remove_duplicates(tail, found)
    else
      remove_duplicates(tail, [head | found])
    end
  end

  def make_group(grid, {cords, entry}, taken_spots, x_bound, y_bound) do
    if Enum.member?(taken_spots, cords) do
      {:taken, []}
    else
      {x, y} = cords

      {:found, search_group(grid, x, y, entry, x_bound, y_bound, []) |> remove_duplicates([])}
    end
  end

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

  def calc_area({_key, cords}) do
    length(cords)
  end

  def check_grid_entry(_grid, _entry, {x, _y}, x_bound, _y_bound) when x < 0 or x > x_bound, do: 1

  def check_grid_entry(_grid, _entry, {_x, y}, _x_bound, y_bound) when y < 0 or y > y_bound, do: 1

  def check_grid_entry(grid, entry, {x, y}, _x_bound, _y_bound) do
    {_search_cords, search_entry} = Enum.at(grid, y) |> Enum.at(x)

    if entry !== search_entry do
      1
    else
      0
    end
  end

  def calc_perimeter(_grid, {_key, []}, _x_bound, _y_bound), do: 0

  def calc_perimeter(grid, {key, [{x, y} | rest_cords]}, x_bound, y_bound) do
    Enum.reduce(@directions, 0, fn {x_dir, y_dir}, acc ->
      acc + check_grid_entry(grid, key, {x + x_dir, y + y_dir}, x_bound, y_bound)
    end) + calc_perimeter(grid, {key, rest_cords}, x_bound, y_bound)
  end

  def main() do
    grid =
      File.read!("hard_input.txt")
      |> handle_input()

    y_bound = length(grid) - 1
    x_bound = length(Enum.at(grid, 0)) - 1

    {real_groups, _} =
      Enum.reduce(grid, {[], []}, fn line, {groups, used} ->
        {made_groups, made_used} =
          Enum.reduce(line, {[], used}, fn {cords, item}, {sub_groups, sub_used} ->
            if Enum.member?(sub_used, cords) do
              {sub_groups, sub_used}
            else
              group =
                case make_group(grid, {cords, item}, sub_used, x_bound, y_bound) do
                  {:found, found_group} -> found_group
                  {:taken, _} -> []
                end

              {
                [{item, group}] ++ sub_groups,
                group ++ sub_used
              }
            end
          end)

        {
          made_groups ++ groups,
          made_used ++ used
        }
      end)

    Enum.map(real_groups, fn group ->
      calc_perimeter(grid, group, x_bound, y_bound) * calc_area(group)
    end)
    |> Enum.sum()
    |> IO.inspect()
  end
end

defmodule Helper do
  def appendInOrder([], item), do: [item]
  def appendInOrder([head | tail], item) when item < head, do: [item, head | tail]
  def appendInOrder([head | tail], item), do: [head | appendInOrder(tail, item)]

  # def findDistances(_, _, total), do: total

  def findDistances(lines, idx, total) do
    first_smallest = lines[:first_order] |> Enum.at(idx)
    second_smallest = lines[:second_order] |> Enum.at(idx)
    secondOffset = Enum.split(lines[:second_order], idx) |> getOffset(second_smallest, 0)

    IO.inspect(secondOffset)
  end

  def getOffset([], _, total), do: total
  def getOffset([_ | tail], search, total), do: getOffset([tail], search, total)

  def getOffset([head | tail], search, total) when head == search,
    do: getOffset([tail], search, total + 1)
end

lines =
  case File.read("./input.txt") do
    {:ok, content} -> content
    {:error, reason} -> raise("Error reading file #{reason}")
  end
  |> String.split("\n")
  |> Enum.reduce(%{first_col: [], second_col: [], first_order: [], second_order: []}, fn line,
                                                                                         acc ->
    items = String.split(line, "   ")

    first_int = Enum.at(items, 0) |> String.to_integer()
    second_int = Enum.at(items, 1) |> String.to_integer()

    Map.update!(acc, :first_col, fn cur ->
      cur ++ [first_int]
    end)
    |> Map.update!(:second_col, fn cur ->
      cur ++ [second_int]
    end)
    |> Map.update!(:first_order, fn cur ->
      Helper.appendInOrder(cur, first_int)
    end)
    |> Map.update!(:second_order, fn cur ->
      Helper.appendInOrder(cur, second_int)
    end)
  end)
  |> Helper.findDistances(0, 0)

IO.inspect(lines, pretty: true)

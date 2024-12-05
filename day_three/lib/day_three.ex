defmodule DayThree do
  @moduledoc """
  Documentation for `DayThree`.
  """

  def handle_numbers([")" | tail], false, first_num, second_num),
    do: {String.to_integer(first_num) * String.to_integer(second_num), tail}

  def handle_numbers(["," | tail], true, first_num, second_num),
    do: handle_numbers(tail, false, first_num, second_num)

  def handle_numbers([head | tail], is_first, first_num, second_num) do
    case Integer.parse(head) do
      {number, ""} ->
        if is_first do
          if String.length(first_num) > 2 do
            {0, tail}
          else
            handle_numbers(
              tail,
              is_first,
              first_num <> Integer.to_string(number),
              second_num
            )
          end
        else
          if String.length(second_num) > 2 do
            {0, tail}
          else
            handle_numbers(
              tail,
              is_first,
              first_num,
              second_num <> Integer.to_string(number)
            )
          end
        end

      _other ->
        {0, tail}
    end
  end

  def tokenize([head | tail], idx, total) do
    order = ["m", "u", "l", "("]

    if head == Enum.at(order, idx) do
      if idx == 3 do
        {add_total, next_chars} = handle_numbers(tail, true, "", "")
        tokenize(next_chars, 0, total + add_total)
      else
        tokenize(tail, idx + 1, total)
      end
    else
      tokenize(tail, 0, total)
    end
  end

  def tokenize([], _, total), do: total

  def main do
    case File.read("input.txt") do
      {:ok, content} -> content
      {:error, reason} -> raise("failed to read file: #{reason}")
    end
    |> String.split("")
    |> tokenize(0, 0)
    |> IO.puts()
  end
end

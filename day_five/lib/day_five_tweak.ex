defmodule DayFiveTweak do
  def handle_input(path) do
    [rules, manuals] = File.read!(path) |> String.split("\n\n")

    rules =
      String.split(rules, "\n")
      |> Enum.map(fn rule ->
        [left, right] = String.split(rule, "|")
        {String.to_integer(left), String.to_integer(right)}
      end)

    manuals =
      String.split(manuals, "\n")
      |> Enum.map(fn manual ->
        String.split(manual, ",")
        |> Enum.map(fn entry ->
          # String.to_integer(String.trim(entry))
          # :erlang.binary_to_integer(String.trim(entry))
          {num, ""} = Integer.parse(String.trim(entry))
          num
        end)
      end)

    IO.inspect(manuals)

    {rules, manuals}
  end

  # def check_order(first_entry, second_entry, [cur_rule | rest_rules]) do
  # end

  # def check_manual(manual, rules) do
  # end

  def main do
    handle_input("input.txt")
  end
end

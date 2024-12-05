defmodule DayFive do
  def handle_input(path) do
    [rules, manuals] = File.read!(path) |> String.split("\n\n")

    rules =
      String.split(rules, "\n")
      |> Enum.map(fn rule ->
        [left, right] = String.split(rule, "|")
        {String.to_integer(left), String.to_integer(right)}
      end)

    # Add debug before processing manuals
    IO.puts("\nDebug before manuals processing:")
    IO.inspect(binding(), label: "Current bindings")
    IO.inspect(Process.info(self(), :dictionary), label: "Process dictionary")

    manuals =
      String.split(manuals, "\n")
      |> tap(fn lines -> IO.inspect(lines, label: "After initial split") end)
      |> Enum.map(fn manual ->
        String.split(manual, ",")
        |> tap(fn entries -> IO.inspect(entries, label: "Line splits") end)
        |> Enum.map(fn entry ->
          # Add more debug info
          IO.inspect(entry, label: "About to parse")
          IO.inspect(Process.info(self(), :dictionary), label: "Dict before parse")
          result = String.to_integer(entry)
          IO.inspect(result, label: "Parse result")
          result
        end)
      end)

    {rules, manuals}
  end

  def main do
    IO.puts("Starting main")
    IO.inspect(Process.info(self(), :dictionary), label: "Process dict at start")
    handle_input("input.txt")
  end
end

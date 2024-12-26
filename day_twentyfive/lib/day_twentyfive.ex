defmodule DayTwentyfive do
  def handle_input(input) do
    String.split(input, "\n\n")
    |> Enum.map(fn block ->
      String.split(block, "\n")
      |> Enum.map(fn line ->
        String.split(line, "", trim: true)
      end)
    end)
  end

  def process_lock(_block, col, _line, shape) when col >= 5, do: shape

  def process_lock(block, col, line, shape) do
    cur_entry = Enum.at(block, line) |> Enum.at(col)

    if cur_entry == "#" do
      last = Enum.at(shape, col)

      n_shape = List.replace_at(shape, col, last + 1)

      process_lock(block, col, line + 1, n_shape)
    else
      process_lock(block, col + 1, 1, shape)
    end
  end

  def process_key(_block, col, _line, shape) when col >= 5, do: shape

  # start the line at 5
  def process_key(block, col, line, shape) do
    cur_entry = Enum.at(block, line) |> Enum.at(col)

    if cur_entry == "#" do
      last = Enum.at(shape, col)

      n_shape = List.replace_at(shape, col, last + 1)

      process_key(block, col, line - 1, n_shape)
    else
      process_key(block, col + 1, 5, shape)
    end
  end

  def make_lock_or_key(block) do
    if Enum.at(block, 0) |> Enum.at(0) == "#" do
      {:lock, process_lock(block, 0, 1, [0, 0, 0, 0, 0])}
    else
      {:key, process_key(block, 0, 5, [0, 0, 0, 0, 0])}
    end
  end

  def test_key_in_lock(_lock, _key, idx) when idx >= 5, do: true

  def test_key_in_lock(lock, key, idx) do
    lock_num = Enum.at(lock, idx)
    key_num = Enum.at(key, idx)

    if lock_num + key_num <= 5 do
      test_key_in_lock(lock, key, idx + 1)
    else
      false
    end
  end

  def main() do
    %{keys: keys, locks: locks} =
      File.read!("input.txt")
      |> handle_input()
      |> Enum.reduce(%{keys: [], locks: []}, fn block, acc ->
        case make_lock_or_key(block) do
          {:lock, shape} -> %{acc | locks: [shape | acc.locks]}
          {:key, shape} -> %{acc | keys: [shape | acc.keys]}
        end
      end)

    Enum.reduce(locks, 0, fn lock, top_acc ->
      Enum.reduce(keys, 0, fn key, sub_acc ->
        if test_key_in_lock(lock, key, 0) do
          sub_acc + 1
        else
          sub_acc
        end
      end) + top_acc
    end)
    |> IO.inspect()
  end
end

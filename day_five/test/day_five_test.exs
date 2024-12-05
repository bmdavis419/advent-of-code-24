defmodule DayFiveTest do
  use ExUnit.Case
  doctest DayFive

  test "greets the world" do
    testing_man = "asdf"
    new_testing_man = "asdf" <> testing_man
    assert DayFive.hello() == :world
  end
end

defmodule Mix.Tasks.RunMain do
  use Mix.Task

  @shortdoc "Runs the main function"
  def run(_) do
    DayTwelve.main()
  end
end

defmodule Printer do
  def start_link(event) do
    IO.puts "starting printer"
    Task.start_link(fn ->
      IO.inspect({self(), event})
    end)
  end
end

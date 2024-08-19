defmodule CambridgeScraperTest do
  use ExUnit.Case
  doctest CambridgeScraper

  test "greets the world" do
    assert CambridgeScraper.hello() == :world
  end
end

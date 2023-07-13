defmodule PineUiTest do
  use ExUnit.Case
  doctest PineUi

  test "greets the world" do
    assert PineUi.hello() == :world
  end
end

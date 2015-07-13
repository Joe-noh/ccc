defmodule NifLoadTest do
  use ExUnit.Case

  test "nif functions are loaded" do
    assert CCC.Converter.nif_ok == :ok
  end
end

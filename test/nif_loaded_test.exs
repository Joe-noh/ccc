defmodule NifLoadTest do
  use ExUnit.Case

  test "nif functions are loaded" do
    assert CCC.Converter.nif_ok == :ok
  end

  test "ccc_iconv_open" do
    assert CCC.Converter.nif_iconv_open("utf-8", "euc-jp") == ""
  end

  test "ccc_iconv_close" do
    cd = CCC.Converter.nif_iconv_open("utf-8", "euc-jp")
    assert CCC.Converter.nif_iconv_close(cd) == :ok
  end

  test "ccc_iconv_convert" do
    cd = CCC.Converter.nif_iconv_open("utf-8", "euc-jp")
    assert CCC.Converter.nif_iconv_convert(cd, "こんにちわ") == 1
    assert CCC.Converter.nif_iconv_close(cd) == :ok
  end
end

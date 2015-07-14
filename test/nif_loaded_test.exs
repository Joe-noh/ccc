defmodule NifLoadTest do
  use ExUnit.Case

  test "nif functions are loaded" do
    assert CCC.Converter.nif_ok == :ok
  end

  test "ccc_iconv_open" do
    assert CCC.Converter.nif_iconv_open("UTF-8", "EUC-JP") == ""
  end

  test "ccc_iconv_close" do
    cd = CCC.Converter.nif_iconv_open("UTF-8", "EUC-JP")
    assert CCC.Converter.nif_iconv_close(cd) == :ok
  end

  test "ccc_iconv_convert" do
    cd = CCC.Converter.nif_iconv_open("EUC-JP", "UTF-8")
    assert CCC.Converter.nif_iconv_convert(cd, <<"こんにちわ"::utf8>>) == 1
    assert CCC.Converter.nif_iconv_close(cd) == :ok
  end
end

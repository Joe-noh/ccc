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
    utf_to_euc = CCC.Converter.nif_iconv_open("EUC-JP", "UTF-8")
    euc_to_utf = CCC.Converter.nif_iconv_open("UTF-8", "EUC-JP")

    utf  = "こんにちわ"
    euc  = CCC.Converter.nif_iconv_convert(utf_to_euc, utf)
    utf2 = CCC.Converter.nif_iconv_convert(euc_to_utf, euc)

    assert utf2 == utf

    assert CCC.Converter.nif_iconv_close(utf_to_euc) == :ok
    assert CCC.Converter.nif_iconv_close(euc_to_utf) == :ok
  end
end

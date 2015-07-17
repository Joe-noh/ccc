defmodule CCCTest do
  use ExUnit.Case

  alias CCC, as: C

  @utf8  "こんにちわ"
  @eucjp <<0xA4, 0xB3, 0xA4, 0xF3, 0xA4, 0xCB, 0xA4, 0xC1, 0xA4, 0xEF>>
  @sjis  <<0x82, 0xB1, 0x82, 0xF1, 0x82, 0xC9, 0x82, 0xBF, 0x82, 0xED>>

  test "convert UTF-8 to EUC-JP and back" do
    assert C.convert(@utf8,  "UTF-8", "EUC-JP") == @eucjp
    assert C.convert(@eucjp, "EUC-JP", "UTF-8") == @utf8
  end

  test "convert UTF-8 to Shift_JIS" do
    assert C.convert(@utf8, "UTF-8", "Shift_JIS") == @sjis
    assert C.convert(@sjis, "Shift_JIS", "UTF-8") == @utf8
  end

  test "convert UTF-8 to EUC-JP" do
    assert C.convert(@eucjp, "EUC-JP", "Shift_JIS") == @sjis
    assert C.convert(@sjis,  "Shift_JIS", "EUC-JP") == @eucjp
  end
end

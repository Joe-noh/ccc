defmodule CCC do
  @moduledoc """
  This module provides a function `convert/3`.
  It converts characterset of given string from `from` to `to`.

      iex> hello_euc = CCC.convert "こんにちわ", "UTF-8", "EUC-JP"
      <<164, 179, 164, 243, 164, 203, 164, 193, 164, 239>>

      iex> CCC.convert hello_euc, "EUC-JP", "UTF-8"
      "こんにちわ"
  """

  @on_load {:init, 0}

  @doc false
  def init do
    :code.priv_dir(:ccc)
    |> :filename.join('iconv')
    |> :erlang.load_nif(0)
  end

  @spec convert(String.t, Strings.t, String.t) :: String.t | {:error, String.t}
  @doc """
  Perform the characterset conversion and returns the result.

  See [libiconv documents](http://www.gnu.org/software/libiconv/) for more info.
  """
  def convert(_string, _from, _to), do: exit(:nif_not_loaded)
end

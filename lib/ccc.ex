defmodule CCC do
  @moduledoc """
  This module provides a function `convert/4`.
  It converts characterset of given `string` from `from` to `to`.

      iex> hello_euc = CCC.convert "こんにちわ", "UTF-8", "EUC-JP"
      <<164, 179, 164, 243, 164, 203, 164, 193, 164, 239>>

      iex> CCC.convert hello_euc, "EUC-JP", "UTF-8"
      "こんにちわ"

  If the `string` contains letters that can't be represented in `to` charscter set,
  `{:error, "invalid multibyte sequence"}` is returned.

      iex> CCC.convert "🍣", "UTF-8", "EUC-JP"
      {:error, "invalid multibyte sequence"}

  Give `discard_unsupported: true` when you want them to be ignored.

      iex> CCC.convert "🍣", "UTF-8", "EUC-JP", discard_unsupported: true
      ""
  """

  @on_load {:init, 0}

  @doc false
  def init do
    :code.priv_dir(:ccc)
    |> :filename.join('iconv')
    |> :erlang.load_nif(0)
  end

  @spec convert(String.t, String.t, String.t, Keyword.t) :: String.t | {:error, String.t}
  @doc """
  Perform the characterset conversion and returns the result.

  See [libiconv documents](http://www.gnu.org/software/libiconv/) for more info.

  ### options

  - `discard_unsupported`: If `true`, the characters that can't be represented in `to` code will be discarded.
  """
  def convert(string, from, to, opts \\ []) do
    if Keyword.get(opts, :discard_unsupported, false) do
      do_convert(string, from, to <> "//IGNORE")
    else
      do_convert(string, from, to)
    end
  end

  defp do_convert(_string, _from, _to), do: exit(:nif_not_loaded)
end

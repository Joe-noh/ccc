defmodule CCC.Converter do
  @on_load {:init, 0}

  def init do
    [__DIR__, ~w[.. .. priv iconv]]
    |> List.flatten
    |> Path.join
    |> String.to_char_list
    |> :erlang.load_nif(0)
  end

  defmacrop nif do
    quote do
      exit(:nif_not_loaded)
    end
  end

  def convert(_string, _from, _to), do: nif
  def nif_iconv_open(_from, _to), do: nif
  def nif_iconv_close(_cd), do: nif
  def nif_iconv_convert(_cd, _input), do: nif

  def nif_ok, do: nif
end

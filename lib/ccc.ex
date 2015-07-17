defmodule CCC do
  @on_load {:init, 0}

  def init do
    [__DIR__, ~w[.. priv iconv]]
    |> List.flatten
    |> Path.join
    |> String.to_char_list
    |> :erlang.load_nif(0)
  end

  def convert(_string, _from, _to), do: exit(:nif_not_loaded)
end

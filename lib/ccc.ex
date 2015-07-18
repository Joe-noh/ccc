defmodule CCC do
  @on_load {:init, 0}

  def init do
    :code.priv_dir(:ccc)
    |> :filename.join('iconv')
    |> :erlang.load_nif(0)
  end

  def convert(_string, _from, _to), do: exit(:nif_not_loaded)
end

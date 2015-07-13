defmodule Mix.Tasks.Compile.Nif do
  use Mix.Task

  @shortdoc "compile C source"

  @compiler "clang"
  @erl_flag "-I#{:code.root_dir}/erts-#{:erlang.system_info :version}/include"
  @c_files  [__DIR__, "c_src", "*.c"] |> Path.join |> Path.wildcard
  @out_opt  "-o #{Path.join [__DIR__, "priv", "iconv.so"]}"

  def run(_) do
    [__DIR__, "priv"]
    |> Path.join
    |> File.mkdir_p!

    [@compiler, @erl_flag, @c_files, shared_opts, @out_opt]
    |> List.flatten
    |> Enum.join(" ")
    |> Mix.shell.cmd
  end

  defp shared_opts, do: ["-shared" | os_shared_opts]

  defp os_shared_opts do
    case :os.type do
      {:unix, :darwin} -> ~w(-dynamiclib -undefined dynamic_lookup)
      _other -> []
    end
  end
end

defmodule CCC.Mixfile do
  use Mix.Project

  def project do
    [app: :ccc,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: [:nif | Mix.compilers],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger],
     mod: {CCC, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
  end
end

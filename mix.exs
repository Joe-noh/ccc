defmodule Mix.Tasks.Compile.Nif do
  use Mix.Task

  @shortdoc "invoke make"

  def run(_) do
    if Mix.shell.cmd("make") != 0, do: Mix.raise "make failed"
  end
end

defmodule CCC.Mixfile do
  use Mix.Project

  def project do
    [app: :ccc,
     version: "0.0.1",
     elixir: "~> 1.0",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: [:nif | Mix.compilers],
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
     {:ex_doc,  "~> 0.7", only: :dev}]
  end

  defp description do
    "Character Code Converter"
  end

  defp package do
    [files: ["lib", "c_src", "mix.exs", "Makefile", "README*", "LICENSE*"],
     build_tools: ["mix"],
     contributors: ["Joe Honzawa"],
     licenses: ["MIT"],
     links: %{
       "GitHub" => "https://github.com/Joe-noh/ccc"
     }]
  end

  defp docs do
    [readme: "README.md", main: "README"]
  end
end

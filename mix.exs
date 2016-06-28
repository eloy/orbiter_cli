defmodule OrbiterCli.Mixfile do
  use Mix.Project

  def project do
    [app: :orbiter_cli,
     version: "0.0.1",
     elixir: "~> 1.2",
     escript: escript,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :hackney]]
  end

  defp deps do
    [
      {:hackney, "~> 1.6"},
      {:poison, "~> 1.5"},
    ]
  end


  # escript
  #----------------------------------------------------------------------

  def escript do
    [main_module: OrbiterCli]
  end

end

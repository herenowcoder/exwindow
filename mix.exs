defmodule Exwindow.Mixfile do
  use Mix.Project

  def project do
    [ app: :exwindow,
      version: "0.0.3-dev",
      elixir: "~> 1.0",
      deps: deps,
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    []
  end

  defp deps do
    [{:excoveralls, "== 0.3.6", only: :test}]
  end
end

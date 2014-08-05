defmodule Exwindow.Mixfile do
  use Mix.Project

  def project do
    [ app: :exwindow,
      version: "0.0.3-dev",
      elixir: "~> 0.14.3 or ~> 0.15.0",
      deps: deps,
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [{:excoveralls, "~> 0.3.1", only: :test}]
  end
end

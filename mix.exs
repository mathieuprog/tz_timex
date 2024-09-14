defmodule TzTimex.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :tz_timex,
      elixir: "~> 1.9",
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),

      # Hex
      version: @version,
      package: package(),
      description: "Timex API for Tz",

      # ExDoc
      name: "TzTimex",
      source_url: "https://github.com/mathieuprog/tz_timex",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:tz, "~> 0.28"},
      {:timex, "~> 3.7", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      licenses: ["Apache-2.0"],
      maintainers: ["Mathieu Decaffmeyer"],
      links: %{
        "GitHub" => "https://github.com/mathieuprog/tz_timex"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}"
    ]
  end
end

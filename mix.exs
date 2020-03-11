defmodule PropCheckCommons.MixProject do
  use Mix.Project

  def project do
    [
      app: :propcheck_commons,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: false,
      deps: deps(),
      # Hex
      package: package(),
      description: description(),
      name: "PropCheckCommons",
      source_url: "https://github.com/k-cross/propcheck_commons",
      docs: [
        # The main page in the docs
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:propcheck, "~> 1.0"},
      {:ex_doc, "~> 0.1", only: :dev},
      {:dialyxir, "~> 1.0-rc7", only: :dev, runtime: false}
    ]
  end

  defp description do
    "A set of common generators for use with PropCheck and ProPEr."
  end

  defp package do
    [
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*
                CHANGELOG*),
      licenses: ["GPL-3.0-only"],
      links: %{"GitHub" => "https://github.com/k-cross/propcheck_commons"}
    ]
  end
end

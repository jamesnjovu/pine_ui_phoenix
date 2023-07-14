defmodule PineUi.MixProject do
  use Mix.Project

  def project do
    [
      app: :pine_ui,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      package: package(),
      name: "Pine UI",
      source_url: "https://github.com/jamesnjovu/pine_ui_phoenix",
      description: "Phoenix components for Pine UI!",
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PineUi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_live_view, "~> 0.18.2"},
      {:poison, "~> 3.1.0"},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  def package do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "pine_ui_phoenix",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jamesnjovu/pine_ui_phoenix"}
    ]
  end
end

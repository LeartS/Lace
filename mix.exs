defmodule Lace.MixProject do
  use Mix.Project

  @version "0.0.2"
  @repo_url "https://github.com/LeartS/lace"

  def project do
    [
      app: :lace,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      # Docs
      name: "Lace",
      source_url: @repo_url,
      homepage_url: @repo_url,
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp description() do
    """
    Lace your Elixir with a finely curated blend of functional utilities, \
    crafted to complement and enhance the standard library.
    """
  end

  defp package() do
    [
      name: "lace",
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE),
      licenses: ["MIT"],
      links: %{
        "GitHub" => @repo_url
      }
    ]
  end

  defp docs() do
    [
      source_ref: "main",
      extras: [
        LICENSE: [title: "License"]
      ]
    ]
  end
end

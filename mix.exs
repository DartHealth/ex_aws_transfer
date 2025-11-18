defmodule ExAwsTransfer.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_aws_transfer,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      description: description(),
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.1"},
      {:jason, "~> 1.2"},
      # Runtime false deps
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    An ExAws library for interacting with AWS Transfer Family.
    """
  end

  defp package do
    [
      name: "ex_aws_transfer",
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/DartHealth/ex_aws_transfer"
      },
      files: ~w(lib mix.exs README* LICENSE* CHANGELOG*),
      maintainers: ["Alex Kibler"],
    ]
  end
end

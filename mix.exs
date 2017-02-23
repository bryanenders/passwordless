defmodule Passwordless.Mixfile do
  use Mix.Project

  def project do
    [
      app: :passwordless,
      build_embedded: Mix.env === :prod,
      deps: deps(),
      description: "Token-based authentication library for Elixir.",
      elixir: "~> 1.4",
      package: package(),
      start_permanent: Mix.env === :prod,
      version: "0.0.2",
    ]
  end

  defp deps, do: [{:ex_doc, ">= 0.0.0", only: :dev}]

  defp package do
    [
      maintainers: ["Bryan Enders"],
      licenses: ["BSD 2-Clause License"],
      links: %{"GitHub" => "https://github.com/endersstocker/passwordless"},
    ]
  end

  def application do
    [mod: {Passwordless.Application, []}, applications: [:crypto]]
  end
end

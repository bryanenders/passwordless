defmodule Passwordless.Mixfile do
  use Mix.Project

  def project do
    [
      app: :passwordless,
      version: "0.0.2",
      elixir: "~> 1.3",
      description: "Passwordless authentication.",
      package: package,
      build_embedded: Mix.env === :prod,
      start_permanent: Mix.env === :prod,
      deps: deps,
    ]
  end

  defp package do
    [
      maintainers: ["Bryan Enders"],
      licenses: ["BSD 2-Clause License"],
      links: %{"GitHub" => "https://github.com/endersstocker/passwordless"},
    ]
  end

  defp deps, do: [{:ex_doc, ">= 0.0.0", only: :dev}]

  def application, do: [mod: {Passwordless, []}, applications: [:crypto]]
end

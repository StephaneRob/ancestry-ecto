defmodule Ancestry.Mixfile do
  use Mix.Project

  def project do
    [app: :ancestry,
     version: "0.1.0-alpha.1",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "Ancestry for Ecto.",
     package: [
       licenses: ["MIT"],
       links: %{"Github" => "https://github.com/StephaneRob/ancestry"},
       maintainers: ["Stéphane ROBINO"]
       ],
     deps: deps()]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ecto, "~> 2.1"},
      {:postgrex, "~> 0.13", only: :test},
    ]
  end
end

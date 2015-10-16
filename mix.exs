defmodule DublinBusApi.Mixfile do
  use Mix.Project

  def project do
    [app: :dublin_bus_api,
     version: "0.1.2-1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     description: "Access to the Real Time Passenger Information (RTPI) for Dublin Bus services.",
     name: "Dublin Bus API",
     source_url: "https://github.com/carlo-colombo/dublin-bus-api",
     package: [
       licenses: ["MIT"],
       mainteiners: ["Carlo Colombo"],
       links: %{
         "Github" => "https://github.com/carlo-colombo/dublin-bus-api",
         "docs" => "http://hexdocs.pm/dublin_bus_api"
       }
     ]]
  end

  def application do
    [applications: [:httpoison,
                   :floki]]
  end

  defp deps do
    [{:floki, "~> 0.3"},
     {:httpoison, "~> 0.7"},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.8", only: :dev},
     {:mock, "~> 0.1.1", only: :test}]
  end
end

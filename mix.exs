defmodule DublinBusApi.Mixfile do
  use Mix.Project

  def project do
    [app: :dublin_bus_api,
     version: "0.1.10",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanentbus: Mix.env == :prod,
     deps: deps(),
     description: "Access to the Real Time Passenger Information (RTPI) for Dublin Bus services.",
     name: "Dublin Bus API",
     source_url: "https://github.com/carlo-colombo/dublin-bus-api",
     test_coverage: [tool: Coverex.Task, coveralls: true],
     docs: [
       main: Stop
     ],
     package: [
       licenses: ["MIT"],
       mainteiners: ["Carlo Colombo"],
       links: %{
         "Github" => "https://github.com/carlo-colombo/dublin-bus-api",
         "docs" => "http://hexdocs.pm/dublin_bus_api/Stop.html"
       }
     ]]
  end

  def application do
    [applications: [:httpoison,
                   :floki]]
  end

  defp deps do
    [{:floki, "~> 0.15"},
     {:httpoison, "~> 0.11"},
     {:poison, "~> 3.0", override: true},
     {:earmark, "~> 1.2", only: :dev},
     {:ex_doc, "~> 0.15", only: :dev},
     {:mock, "~> 0.2.1", only: :test},
     {:credo, "~> 0.7", only: [:test, :dev]},
     {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
     {:coverex, "~> 1.4.12", only: :test}]
  end
end

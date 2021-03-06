defmodule FixturesAgent do
  @moduledoc """
  Fixtures Agent
  =============

  Simple agent that rotate through a list of string, wrapping them with an HTTPoison.Response

  """

  def new(fixtures) do
    Agent.start_link(fn -> fixtures end)
  end

  defp rotate([resp|t]) do
    {{:ok,
      %HTTPoison.Response{status_code: 200,
                          body: resp}}, t ++ [resp]}
  end
  def next(pid) do
    Agent.get_and_update(pid, &rotate/1)
  end
  def get(pid) do
    Agent.get(pid, fn(n) -> n end)
  end
end

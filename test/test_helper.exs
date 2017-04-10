ExUnit.start()

defmodule TestHelper do
  defmacro with_response_from_fixture(fixturefiles, do: body) do
    fixtures = fixturefiles
    |> Task.async_stream(fn f -> {_, fixture} = File.read(f); fixture end)
    |> Enum.to_list
    |> Enum.map(fn {:ok, resp} -> resp end)

    quote do
      {:ok, pid} = FixturesAgent.new(unquote(fixtures))

      with_mock HTTPoison, [get: fn(_url) -> FixturesAgent.next(pid) end,
                            post: fn(_url,_body,_headers) -> FixturesAgent.next(pid) end,
                            get: fn(_,_,_) -> FixturesAgent.next(pid) end], do: unquote(body)
    end
  end
end


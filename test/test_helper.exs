ExUnit.start()

defmodule TestHelper do
  defmacro with_response_from_fixture(fixturefiles, do: body) do
    fixtures = fixturefiles
    |> Task.async_stream(fn f -> {:ok, fixture} = File.read(f); fixture end)
    |> Enum.to_list
    |> Enum.map(fn t-> {:ok, x} = t; x end)

    quote do
      i = 0
      fixtures = unquote(fixtures)
      resp = Enum.at(fixtures, rem(i, length(fixtures)))
      resp = {:ok,
              %HTTPoison.Response{status_code: 200,
                                  body: resp}}

      with_mock HTTPoison, [get: fn(_url) -> i=i+1; resp  end,
                            post: fn(_url,_body,_headers) -> i=i+1; resp end,
                            get: fn(_,_,_) -> i=i+1; resp end], do: unquote(body)
    end
  end

  # defmacro with_response_from_fixture(fixturefile, do: body) when is_binary(fixturefile) do
  #   {:ok, fixture } = File.read(fixturefile)
  #   quote do
  #     resp = {:ok,
  #             %HTTPoison.Response{status_code: 200,
  #                                 body: unquote(fixture)}}

  #     with_mock HTTPoison, [get: fn(_url) -> resp  end,
  #                           post: fn(_url,_body,_headers) -> resp end,
  #                           get: fn(_,_,_) -> resp end], do: unquote(body)
  #   end
  # end
end

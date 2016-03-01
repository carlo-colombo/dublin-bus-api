ExUnit.start()

defmodule TestHelper do
  defmacro with_response_from_fixture(fixturefile, do: body) do
    {:ok, fixture } = File.read(fixturefile)
    quote do
      resp = {:ok,
       %HTTPoison.Response{status_code: 200,
                           body: unquote(fixture)}}

      with_mock HTTPoison, [get: fn(_url) -> resp  end,
                           post: fn(_url,_body,_headers) -> resp end,
                           get: fn(_,_,_) -> resp end], do: unquote(body)
    end
  end
end

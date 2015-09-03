ExUnit.start()

defmodule TestHelper do
  defmacro with_response_from_fixture(fixturefile, do: body) do
    quote do
      {:ok, fixture } = File.read(unquote(fixturefile))
      with_mock HTTPoison, [get: fn(_url) -> {:ok,
                                             %HTTPoison.Response{status_code: 200,
                                                                 body: fixture}}  end,
                             post: fn(_url,_body,_headers) -> {:ok,
                                                              %HTTPoison.Response{status_code: 200,
                                                                                  body: fixture}}  end], do: unquote(body)
    end
  end
end

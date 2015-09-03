defmodule Stop do
  defstruct name: nil, ref: nil, timetable: [], lines: []

  def get_info(id) when is_binary(id) do
    stop = String.rjust(id,5,?0)
    url = "http://rtpi.ie/Popup_Content/WebDisplay/WebDisplay.aspx?stopRef=#{stop}"

    body = HTTPoison.get(url)
     |> get_body

    timetable = Floki.find(body,".gridRow")
     |> Enum.map(&parse_row/1)

    name = Floki.find(body, "#stopTitle")
     |> Floki.text
     |> String.split("-")
     |> List.first
     |> String.strip

    %Stop{
      ref: stop,
      name: name,
      timetable: timetable
    }
  end

  def get_info(id) do
    get_info(Integer.to_string(id))
  end

  def search(q) do
    url = "http://rtpi.ie/Text/StopResults.aspx?did=-1&search=#{q}"

    HTTPoison.get(url)
     |> get_body
     |> Floki.find("#GridViewStopResults")
     |> Tuple.to_list
     |> List.last # look for the children of the table (tr)
     |> tl        # discard the header
     |> Enum.map(&parse_stop/1)

  end

  defp get_body({:ok,
                 %HTTPoison.Response{status_code: 200,
                                     body: body}}) do
    body
  end


  defp parse_stop({"tr", _ ,
                   [{"td",_ , [line]},
                    {"td",_ , [name]}, lines_html ]}) do

    lines = lines_html
    |> Floki.find("tr")
    |> Enum.map(&Floki.find(&1,"td"))
    |> Enum.map(fn x -> Enum.map(x, &Floki.text/1) |> List.to_tuple end )
    |> Enum.into(%{})

    %Stop{name: Floki.text(name),
          ref: line,
          lines: lines  }
  end

  defp parse_row({"tr", _,
                   [{"td", [{"class", "gridServiceItem"}, _], [line]},
                    {"td", [{"class", "gridDestinationItem"}, _],
                     [{"span", [{"title", terminus}, _], [direction]}]},
                    {"td", [{"class", "gridTimeItem"}, _], [time]}, _]}) do

    %{time: time,
      line: line,
      terminus: terminus,
      direction: direction}
  end
end

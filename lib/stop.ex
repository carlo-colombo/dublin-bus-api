defmodule Stop do

  defstruct name: nil, ref: nil, timetable: [], lines: []

  @last_time_checked {2015, 12, 23}
  @last_time_checked_formatted @last_time_checked
  |> Tuple.to_list
  |> Enum.join("-")

  @moduledoc """
  Dublin Bus API
  =============

  Access to the Real Time Passenger Information (RTPI) for Dublin Bus services.

  The API are focused on retrieving bus stop and timetables

  Disclaimer
  ----------

  This service is in no way affiliated with Dublin Bus or the providers of the RTPI service.

  Data are retrieved parsing the still-in-development [RTPI](http://rtpi.ie/) site. As with any website
  scraping the html could change without notice and break the API.

  Rtpi.ie html parsing work as **#{@last_time_checked_formatted}**


  Test
  -----
  Parsing function are tested both against fixture and the actual website, this could lead to failing test if an
  internet connection is missing. It also could find if something has changed in the rtpi.ie website html.
  """

  defmodule Row do
    defstruct [:line, :direction, :time]
  end

  @info_url "http://rtpi.ie/Popup_Content/WebDisplay/WebDisplay.aspx?stopRef="
  @search_url  "http://rtpi.ie/Text/StopResults.aspx?did=-1&search="


  @typedoc """
  A struct that represent a row in a bus stop timetable, time could be an absolute (16:13) or relative time (5m).
  """
  @type row :: %Row{
    line: String.t,
    direction: String.t,
    time: String.t
  }

  @typedoc """
  A struct that represent a single stop, it could contain the `timetable` or the `lines` that serve the stop.

  `name` and `ref` are always available
  """
  @type stop :: %Stop{
    name: String.t,
    ref: String.t,
    lines: list(String.t),
    timetable: list(row)}

  @doc """
  Return the last time it was checked that the html parsing is still working
  """
  def last_time_checked(), do: @last_time_checked

  @doc """
  Return the last time it was checked that the html parsing is still working as a string (yyyy-MM-dd)
  """
  def last_time_checked_formatted, do: @last_time_checked_formatted

  @doc"""
  Return the requested `Stop`
  """
  @spec get_info(String.t) :: stop
  def get_info(id) when is_binary(id) do
    stop = String.rjust(id,5,?0)

    body = HTTPoison.get(@info_url <> stop)
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

  @spec get_info(Integer.t) :: stop
  def get_info(id) do
    get_info(Integer.to_string(id))
  end

  @doc """
  Return a list of `Stop` matching the `query` provided. It only returns the first ten results
  """
  @spec search(String.t) :: list(stop)
  def search(query) do

    HTTPoison.get(@search_url <> query)
    |> get_body
    |> Floki.find("#GridViewStopResults")
    |> hd        # get the only element
    |> Tuple.to_list
    |> List.last # look for the children of the table (tr)
    |> tl        # discard the header
    |> Enum.map(&parse_stop/1)
    |> Enum.reject(&is_nil(&1))

  end

  defp get_body({:ok,
                 %HTTPoison.Response{status_code: 200,
                                     body: body}}) do
    body
  end


  defp parse_stop({"tr", _ ,
                   [{"td",_ , [line]},
                    {"td",_ , [name]}, lines_html ]}) do

    lines = try do
              lines_html
              |> Floki.find("tr")
              |> Enum.map(&Floki.find(&1,"td"))
              |> Enum.map(fn x -> Enum.map(x, &Floki.text/1) |> List.to_tuple end )
              |> Enum.into(%{})
            rescue
              _ -> %{}
            end

    %Stop{name: Floki.text(name),
          ref: line,
          lines: lines  }
  end

  defp parse_stop(_), do: nil

  defp parse_row({"tr", _,
                  [{"td", [{"class", "gridServiceItem"}, _], [line]},
                   {"td", [{"class", "gridDestinationItem"}, _],
                    [{"span", _, [direction]}]},
                   {"td", [{"class", "gridTimeItem"}, _], [time]}, _]}) do

    %Row{time: time,
         line: line,
         direction: direction}
  end
end

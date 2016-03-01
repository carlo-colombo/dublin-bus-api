defmodule StopTest do
  use ExUnit.Case, async: true

  import Mock

  require TestHelper

  test "get_info on fixture (macro)" do
    TestHelper.with_response_from_fixture ("test/fixture/WebDisplay.html") do
      resp = Stop.get_info("112")
      timetable = resp.timetable

      assert resp.name == "Neilstown Road"
      assert Enum.count(timetable) == 5
      assert resp.__struct__ == Stop
    end
  end

  test "get_info works with a number too" do
    TestHelper.with_response_from_fixture ("test/fixture/WebDisplay.html") do
      Stop.get_info(112)
    end
  end

  test "executing get_info request" do
    resp = Stop.get_info("112")

    assert resp.name == "Ballymun Road"
    assert resp.__struct__ == Stop
  end


  test "search with fixture" do
    TestHelper.with_response_from_fixture "test/fixture/StopResults.html" do
      resp = Stop.search("not important")
      first = List.first(resp)

      assert Enum.count(resp) == 4
      assert first.name == "D'Olier Street"
      assert first.ref == "00333"
      assert first.__struct__ == Stop

      assert Enum.count(first.lines) == 2
      assert %{"32X, 41X" => "UCD Belfield" } = first.lines
    end
  end

  test "search should handle stops with no services" do
    TestHelper.with_response_from_fixture "test/fixture/StopResults2.html" do
      resp = Stop.search("dundrum")
      third = Enum.at(resp,2)

      assert third.lines == %{}
    end
  end

  test "search should return max ten results" do
    TestHelper.with_response_from_fixture "test/fixture/StopResults2.html" do
      resp = Stop.search("dundrum")

      assert Enum.count(resp) == 10
    end
  end

  test "search with request (d'olier)" do
    resp = Stop.search("d'olier")
    first = List.first(resp)

    assert Enum.count(resp) == 4
    assert first.name == "D'Olier Street"
    assert first.ref == "00333"
    assert first.__struct__ == Stop
  end

  test "search with request (dundrum)" do
    resp = Stop.search("dundrum")
    first = List.first(resp)

    assert Enum.count(resp) == 10
    assert first.name == "Dundrum"
    assert first.ref == "02826"
    assert first.__struct__ == Stop
  end

  test "search with request (Sandwith Street)" do
    resp = Stop.search("Sandwith Street")
    first = List.first(resp)

    assert Enum.count(resp) == 1
    assert first.name == "Sandwith Street"
    assert first.ref == "00350"
    assert first.__struct__ == Stop
  end
end

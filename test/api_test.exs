defmodule ApiTest do
  use ExUnit.Case, async: true

  alias Stockfighter.Api, as: A

  test "check the api is up" do
    assert %{"ok" => true, "error" => ""} == A.heartbeat
  end

  test "check a venue is up" do
    assert %{"ok" => true, "venue" => "TESTEX"} == A.venue_heartbeat("TESTEX")
  end

  test "stocks on a venue" do
    expected =
      %{"ok" => true,
        "symbols" =>
          [%{"name"   => "Foreign Owned Occluded Bridge Architecture Resources",
             "symbol" => "FOOBAR"}]}

    assert expected == A.stocks("TESTEX")
  end

  test "the orderbook for a stock" do
    assert %{
      "asks" => _,
      "bids" => _,
      "symbol" => "FOOBAR",
      "venue" => "TESTEX"
    } = A.orderbook("TESTEX", "FOOBAR")
  end

  test "a new order for a stock" do
    assert %{"account" => "EXB123456", "direction" => "buy", "fills" => _, "id" => _,
             "ok" => true, "open" => true, "orderType" => "limit", "originalQty" => 2,
             "price" => 5342, "qty" => 2, "symbol" => "FOOBAR", "totalFilled" => _,
             "ts" => _, "venue" => "TESTEX"}
    = A.new_order("EXB123456", "TESTEX", "FOOBAR", 5342, 2, "buy", "limit")
  end

  test "a quote for a stock" do
    assert %{"ok"        => true,
             "ask"       => _,
             "askDepth"  => _,
             "askSize"   => _,
             "bid"       => _,
             "bidDepth"  => _,
             "bidSize"   => _,
             "last"      => _,
             "lastSize"  => _,
             "lastTrade" => _,
             "quoteTime" => _,
             "symbol"    => "FOOBAR",
             "venue"     => "TESTEX"} = A.stock_quote("TESTEX", "FOOBAR")
  end
end

defmodule Stockfighter.OrderBook do
  use GenServer
  alias Stockfighter.Api, as: A

  ##############
  # Client API #
  ##############

  def start_link([venue, symbol], opts \\ [timeout: 10_000]) do
    GenServer.start_link(__MODULE__, [venue, symbol], opts ++ [name: __MODULE__])
  end

  #############
  # Callbacks #
  #############

  def init([venue, symbol]) do
    ob = A.orderbook(venue, symbol)
    {:ok, ob}
  end

  def handle_info(%{"ok" => true, "quote" => %{"ask" => ask, "askSize" => qty}} = data,
                  %{"asks" => asks, "symbol" => s, "venue" => v} = state) do

    # a = %{"isBuy" => false, "price" => ask, "qty" => qty}
    # asks = [a|asks] |> Enum.sort_by(&Map.fetch!(&1, "price"))

    # IO.inspect a
    # IO.puts "1==========="
    # IO.inspect asks
    # IO.puts "2==========="
    # state = state |> Map.put("asks", asks)
    # IO.inspect state
    # IO.puts "3==========="
    state = A.orderbook(v, s)
    {:noreply, state}
  end

  def handle_info(_data, state) do
    {:noreply, state}
  end
end

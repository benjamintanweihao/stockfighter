defmodule Stockfighter.ChockABlock do
  use GenServer
  alias Stockfighter.Api, as: A

  ##############
  # Client API #
  ##############

  def start_link([a, v, s, q], opts \\ []) do
    GenServer.start_link(__MODULE__, %{account: a, venue: v, stock: s, qty: q},
      opts ++ [name: __MODULE__])
  end

  #############
  # Callbacks #
  #############

  def init(state) do
    {:ok, state}
  end

  def handle_info(%{"ok" => true, "quote" => %{"ask" => ask, "askSize" => qty}},
    %{account: a, venue: v, stock: s, qty: q} = state) do

    if :rand.uniform > 0.9 do
      # buy just 10% of what seller is willing to sell
      q_to_buy = 0.1 * qty |> trunc
      order    = A.new_order(a, v, s, ask, q_to_buy, "buy", "limit")
      IO.inspect order
      case order do
        %{"ok" => true, "totalFilled" => tf} ->
          state = state |> Map.put(:qty, q - tf)
          IO.inspect state
          {:noreply, state}
        _ ->
          {:noreply, state}
      end
    else
      {:noreply, state}
    end
  end

  def handle_info(msg, state) do
    {:noreply, state}
  end
end

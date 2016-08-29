defmodule Stockfighter.ChockABlock do
  use GenServer
  alias Stockfighter.Api, as: A

  #######
  # API #
  #######

  def start_link(account, venue, stock, qty, opts \\ []) do
    GenServer.start_link(__MODULE__, %{account: account, venue: venue, stock: stock, qty: qty}, opts)
  end

  #############
  # Callbacks #
  #############

  def init(state) do
    order!
    {:ok, state}
  end

  def handle_info(:make_order, %{account: a, venue: v, stock: s, qty: q} = state) when q >= 0 do
    order!

    case A.stock_quote(v, s) do
      %{"ask" => ask} ->
        order = A.new_order(a, v, s, ask, 1000, "buy", "limit")
        IO.inspect order
        %{"ok" => true, "totalFilled" => tf} = order
        {:noreply, %{account: a, venue: v, stock: s, qty: q - tf}}

      _ ->
        {:noreply, state}
    end
  end

  def handle_info(_, _state) do
    {:noreply, :ok}
  end

  #####################
  # Private Functions #
  #####################

  defp order! do
    Process.send_after(self, :make_order, 5_000)
  end
end

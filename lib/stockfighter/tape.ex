defmodule Stockfighter.Tape do
  @domain "wss://api.stockfighter.io"

  alias Stockfighter.OrderBook
  alias Stockfighter.ChockABlock

  def start_link([trading_account, venue, stock]) do
    pid = spawn_link(__MODULE__, :tick, [trading_account, venue, stock])
    {:ok, pid}
  end

  def tick(trading_account, venue, stock) do
    socket = Socket.connect! url(trading_account, venue, stock)
    do_tick(socket, trading_account, venue, stock)
  end

  defp do_tick(socket, trading_account, venue, stock) do
    case socket |> Socket.Web.recv! do
      {:text, data} ->
        ChockABlock |> send(Poison.decode!(data))
        do_tick(socket, trading_account, venue, stock)

      {:ping, _ } ->
        socket |> Socket.Web.send!({:pong, ""})
        do_tick(socket, trading_account, venue, stock)

      _ ->
        tick(trading_account, venue, stock)
    end
  end

  defp url(trading_account, venue, stock) do
    @domain <> "/ob/api/ws/#{trading_account}/venues/#{venue}/tickertape/stocks/#{stock}"
  end
end

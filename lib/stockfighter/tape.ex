defmodule Stockfighter.Tape do
  @domain "wss://api.stockfighter.io"

  def tick(trading_account, venue) do
    socket = Socket.connect! url(trading_account, venue) 
    do_tick(socket, trading_account, venue)
  end

  defp do_tick(socket, trading_account, venue) do
    case socket |> Socket.Web.recv! do
      {:text, data} ->
        decoded = data |> Poison.decode!
        do_tick(socket, trading_account, venue)

      {:ping, _ } ->
        socket |> Socket.Web.send!({:pong, ""})
        do_tick(socket, trading_account, venue)

      _ ->
        tick(trading_account, venue)
    end
  end

  defp url(trading_account, venue) do
    @domain <> "/ob/api/ws/#{trading_account}/venues/#{venue}/tickertape"
  end
end

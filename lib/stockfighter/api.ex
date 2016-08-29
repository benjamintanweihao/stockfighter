defmodule Stockfighter.Api do
  use GenServer

  @api_key "2b2236212d4d137ffbdf2c5980aa01200e32786f"

  #######
  # API #
  #######

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def heartbeat do
    process!("/heartbeat")
  end

  def venue_heartbeat(venue) do
    process!("/venues/#{venue}/heartbeat")
  end

  def stocks(venue) do
    process!("/venues/#{venue}/stocks")
  end

  def orderbook(venue, stock) do
    process!("/venues/#{venue}/stocks/#{stock}")
  end

  def new_order(account, venue, stock, price, qty, direction, order_type \\ "limit") do
    {:ok, params} = %{
      account: account,
      venue: venue,
      stock: stock,
      price: price,
      qty: qty,
      direction: direction,
      orderType: order_type,
    } |> Poison.encode

    u = url("/venues/#{venue}/stocks/#{stock}/orders")

    with %{status_code: 200, body: body} <- HTTPoison.post!(u, params, headers),
         {:ok, json} <- Poison.decode(body),
      do: json
  end

  def stock_quote(venue, stock) do
    process!("/venues/#{venue}/stocks/#{stock}/quote")
  end

  #############
  # Callbacks #
  #############

  def init(:ok) do
    {:ok, []} = HTTPoison.start
    {:ok, []}
  end

  #####################
  # Private Functions #
  #####################

  defp url(endpoint \\ "") do
    "https://api.stockfighter.io/ob/api" <> endpoint
  end

  defp headers do
    [
      "X-Starfighter-Authorization": @api_key
    ]
  end

  defp process!(endpoint) do
    url(endpoint)
    |> HTTPoison.get!(headers)
    |> process_body
    |> Poison.decode!
  end

  defp process_body(%HTTPoison.Response{status_code: 200, body: body}) do
    body
  end
  defp process_body(%HTTPoison.Response{status_code: 404}) do
    :not_found
  end
  defp process_body(%HTTPoison.Response{status_code: 500}) do
    :timeout
  end
  defp process_body(_) do
    :error
  end
end

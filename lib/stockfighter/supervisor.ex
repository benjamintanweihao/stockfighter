defmodule Stockfighter.Supervisor do
  use Supervisor
  alias Stockfighter.Tape
  alias Stockfighter.ChockABlock

  def start_link(trading_account, venue, symbol) do
    Supervisor.start_link(__MODULE__, [trading_account, venue, symbol])
  end

  def init([trading_account, venue, symbol]) do
    children = [
      worker(Tape, [[trading_account, venue, symbol]]),
      worker(ChockABlock, [[trading_account, venue, symbol, 100_000]]),
    ]

    supervise(children, strategy: :one_for_one)
  end
end

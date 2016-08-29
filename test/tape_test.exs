defmodule TapeTest do
  use ExUnit.Case

  alias Stockfighter.Tape, as: T

  # TODO: Fix this.
  test "smoke" do
    assert :ok == T.tick("BRM78277225", "PWBEX") 
  end

  def url(trading_account, venue) do
    @domain <> "/ob/api/ws/#{trading_account}/venues/#{venue}/tickertape"
  end
end

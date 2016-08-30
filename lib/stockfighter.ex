defmodule Stockfighter do
  use Application

  def start(_type, [ta, v, s]) do
    Stockfighter.Supervisor.start_link(ta, v, s)
  end
end

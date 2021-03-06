defmodule Wechat.Workers.JSAPITicket do
  @moduledoc false

  use GenServer

  alias Wechat.Ticket

  @name __MODULE__
  @refresh_interval :timer.minutes(30)

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: @name)
  end

  def init(_) do
    state = do_refresh()
    {:ok, state}
  end

  def handle_call(:get, _from, state) do
    {:reply, state["ticket"], state}
  end

  def handle_info(:refresh, _state) do
    state = do_refresh()
    {:noreply, state}
  end

  defp do_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
    Ticket.jsapi_ticket
  end

  def get do
    GenServer.call(@name, :get)
  end
end

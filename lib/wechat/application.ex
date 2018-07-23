defmodule Wechat.Application do
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    children =
      if Application.get_all_env(:wechat)[:appid] do
        [
          {Wechat.Workers.AccessToken, []},
          {Wechat.Workers.JSAPITicket, []},
          {Task.Supervisor, [name: Wechat.TaskSupervisor]}
        ]
      else
        []
      end
    opts = [strategy: :one_for_one, name: Wechat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

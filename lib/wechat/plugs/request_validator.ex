defmodule Wechat.Plugs.RequestValidator do
  @moduledoc false

  import Plug.Conn

  import Wechat.Config, only: [token: 0]
  alias Wechat.Utils.SignatureVerifier

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn = fetch_query_params(conn)
    %{"timestamp" => timestamp, "nonce" => nonce,
      "signature" => signature} = conn.query_params
    if SignatureVerifier.verify?([token(), timestamp, nonce], signature) do
      conn
    else
      conn |> send_resp(400, "") |> halt
    end
  end
end

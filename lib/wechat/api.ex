defmodule Wechat.API do
  @moduledoc false
  require Logger
  alias Wechat.Config

  use Wechat.HTTP, host: Config.config[:api_host]

  def access_token do
    request = %{ grant_type: :client_credential, appid: Config.appid, secret: Config.secret }
    url = "/token"
    Logger.debug "[Wechat] url=#{Config.config[:api_host]}#{url}, request=#{inspect(request)}"
    response = get url, request
    Logger.debug "[Wechat] response #{inspect(response)}"
    response
  end

  def clear_quota do
    post "/clear_quota", %{
      appid: Config.appid
    }
  end

  def upload(url, file, params \\ %{}) do
    post url, {:multipart, [{:file, file}]}, params
  end

  def download(url, params \\ %{}) do
    get url, params
  end
end

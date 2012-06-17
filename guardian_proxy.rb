require "rack-proxy"

class GuardianProxy < Rack::Proxy
  def rewrite_env env
    env["HTTP_HOST"] = "www.guardian.co.uk"
    env["SERVER_PORT"] = 80
    env
  end

  def rewrite_response triplet
    triplet
  end
end

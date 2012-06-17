require "sinatra"
require "sinatra-twitter-oauth"
require "./guardian_proxy"

BASE_URL = ENV["base-url"] || "http://localhost:9292"

set :twitter_oauth_config, key: ENV["consumer-key"],
  secret: ENV["consumer-secret"],
  callback: "#{BASE_URL}/auth",
  login_template: {text: %{<a href="#{BASE_URL}/connect">Sign in with Twitter</a>}}

use GuardianProxy

get "/" do
  login_required
  "Hello #{user.screen_name}!"
end

run Sinatra::Application

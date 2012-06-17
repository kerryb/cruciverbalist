require "sinatra"
require "sinatra-twitter-oauth"
require "./guardian_proxy"

BASE_URL = "http://cruciverbalist.herokuapp.com"

set :twitter_oauth_config, key: ENV["consumer-key"],
  secret: ENV["consumer-secret"],
  callback: "#{BASE_URL}/auth",
  login_template: {text: %{<a href="#{BASE_URL}/connect">Sign in with Twitter</a>}}


get "/" do
  login_required
  "Hello #{user.screen_name}!"
end

map('/crosswords') do
  run GuardianProxy.new
end

run Sinatra::Application

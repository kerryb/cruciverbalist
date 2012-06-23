require "sinatra"
require "sinatra-twitter-oauth"
require "./guardian_proxy"
require 'sprockets'

BASE_URL = ENV["base-url"] || "http://cruciverbalist.dev"

set :twitter_oauth_config, key: ENV["consumer-key"],
  secret: ENV["consumer-secret"],
  callback: "#{BASE_URL}/auth",
  login_template: {text: %{<a href="#{BASE_URL}/connect">Sign in with Twitter</a>}}

use GuardianProxy

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'assets/js'
  environment.append_path 'assets/js/lib'
  environment.append_path 'assets/css'
  run environment
end

get "/" do
  login_required
  "Hello #{user.screen_name}!"
end

get "/chat" do
  haml :chat
end
run Sinatra::Application

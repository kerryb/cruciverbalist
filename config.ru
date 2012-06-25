require "bundler/setup"
require "json"
require "firehose"
require "sinatra"
require "sinatra-twitter-oauth"
require "sprockets"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "db"
require "guardian_proxy"
require "message"

BASE_URL = ENV["base-url"] || "http://cruciverbalist.dev"

set :twitter_oauth_config,
  key: ENV["consumer-key"],
  secret: ENV["consumer-secret"],
  callback: "#{BASE_URL}/auth",
  login_template: {text: %{<a href="#{BASE_URL}/connect">Sign in with Twitter</a>}}

use GuardianProxy

map "/assets" do
  environment = Sprockets::Environment.new
  gem_path = Gem.loaded_specs["firehose"].full_gem_path
  environment.append_path File.join(gem_path, "lib/assets/flash")
  environment.append_path File.join(gem_path, "lib/assets/javascripts")
  environment.append_path "assets"
  run environment
end

get "/" do
  login_required
  "Hello #{user.screen_name}!"
end

get "/chat" do
  @messages = Message.all
  haml :chat
end

post "/chat/messages" do
  message = Message.create JSON.parse(request.body.read)
  message.to_json
end

run Sinatra::Application

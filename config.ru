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

BASE_URL = ENV["BASE_URL"] || "http://cruciverbalist.dev"
FIREHOSE_URL = ENV["FIREHOSE_URL"] || "//localhost:7474"
FIREHOSE_PRODUCER = Firehose::Producer.new FIREHOSE_URL

set :twitter_oauth_config,
  key: ENV["CONSUMER_KEY"],
  secret: ENV["CONSUMER_SECRET"],
  callback: "#{BASE_URL}/auth",
  login_template: {text: %{<a href="#{BASE_URL}/connect">Log in with Twitter</a>}}

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
  login_required
  @messages = Message.all
  @username = user.screen_name
  haml :chat
end

post "/chat/messages" do
  login_required
  message = Message.create JSON.parse(request.body.read).merge username:(user.screen_name)
  message.to_json
end

enable :sessions

use GuardianProxy
run Sinatra::Application

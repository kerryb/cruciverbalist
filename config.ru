require "bundler/setup"
require "json"
require "pusher"
require "sinatra"
require "sinatra-twitter-oauth"
require "sprockets"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "db"
require "requested_page"
require "guardian_proxy"
require "conversation"
require "message"

BASE_URL = ENV["BASE_URL"]

Pusher.app_id = ENV["PUSHER_APP_ID"]
Pusher.key = ENV["PUSHER_KEY"]
Pusher.secret = ENV["PUSHER_SECRET"]


set :twitter_oauth_config,
  key: ENV["TWITTER_CONSUMER_KEY"],
  secret: ENV["TWITTER_CONSUMER_SECRET"],
  callback: "#{BASE_URL}/auth",
  login_template: {text: %{<a href="#{BASE_URL}/connect">Log in with Twitter</a>}}

map "/assets" do
  environment = Sprockets::Environment.new
  environment.append_path "assets"
  run environment
end

get "/" do
  login_required
  redirect request.cookies["requested_page"] || "/crosswords"
end

get "/header" do
  login_required
  @username = user.screen_name
  haml :header
end

get %r{/chat/(.*)} do |crossword|
  login_required
  @conversation = Conversation.for_crossword(crossword)
  @messages = @conversation.messages
  @username = user.screen_name
  haml :chat
end

get "/conversation/:id/messages" do
  login_required
  conversation = Conversation.find params[:id]
  messages = conversation.messages
  messages.to_json
end

post "/conversation/:id/messages" do
  login_required
  conversation = Conversation.find params[:id]
  content = JSON.parse(request.body.read)["content"]
  message = conversation.create_message user.screen_name, content
  Pusher["conversation-#{params[:id]}"].trigger "new-chat-message", message: message.to_json
  message.to_json
end

enable :sessions

use RequestedPage::SaveCookie
use GuardianProxy
run Sinatra::Application

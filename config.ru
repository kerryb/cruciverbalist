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
require "crossword"
require "message"
require "cell"

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
  # Put back in once https://github.com/kerryb/cruciverbalist/issues/1 fixed
  #redirect request.cookies["requested_page"] || "/crosswords"
  redirect "/crosswords"
end

get "/header" do
  login_required
  @username = user.screen_name
  haml :header
end

get %r{/sidebar/(.*)} do |path|
  login_required
  @crossword = Crossword.with_path path
  @messages = @crossword.messages
  @username = user.screen_name
  post_message @crossword, @username, "/me has joined"
  haml :chat
end

get "/crossword/:id/messages" do
  login_required
  crossword = Crossword.find params[:id]
  crossword.messages.to_json
end

post "/crossword/:id/messages" do
  login_required
  crossword = Crossword.find params[:id]
  content = request.body.read
  post_message crossword, user.screen_name, content
end

get "/crossword/:crossword_id/grid" do
  login_required
  crossword = Crossword.find params[:crossword_id]
  crossword.cells.to_json
end

post "/crossword/:crossword_id/grid/:cell_id" do
  login_required
  crossword = Crossword.find params[:crossword_id]
  content = request.body.read
  cell = crossword.create_cell user.screen_name, params[:cell_id], content
  Pusher["grid-#{params[:crossword_id]}"].trigger "new-cell", message: cell.to_json
end

helpers do
  def post_message crossword, username, content
    message = crossword.create_message username, content
    Pusher["chat-#{params[:id]}"].trigger "new-chat-message", message: message.to_json
  end
end

enable :sessions

use RequestedPage::SaveCookie
use GuardianProxy
run Sinatra::Application

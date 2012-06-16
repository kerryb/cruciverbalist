require "sinatra"
require "sinatra-twitter-oauth"

set :twitter_oauth_config, key: ENV["consumer-key"],
  secret: ENV["consumer-secret"],
  callback: "http://cruciverbalist.herokuapp.com/auth"

get "/" do
  login_required
  "Hello #{user.screen_name}!"
end

run Sinatra::Application

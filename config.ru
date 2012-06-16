require "sinatra"
require "sinatra-twitter-oauth"

set :twitter_oauth_config, key: ENV["consumer-key"],
  secret: ENV["consumer-secret"],
  callback: "http://cruciverbalist.herokuapp.com/auth"

get "/" do
  login_required
  <<-EOF
  Hello #{user.inspect}!

  Session:

  <pre>
    #{session.inspect}
  </pre>
  EOF
end

run Sinatra::Application

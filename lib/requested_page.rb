module RequestedPage
  class SaveCookie
    def initialize app
      @app = app
    end

    def call env
      status, headers, body = @app.call env
      response = Rack::Response.new body, status, headers
      request = Rack::Request.new env
      if request.path =~ %r{^/crosswords/\w+/\d+$}
        response.set_cookie "requested_page", value: request.path, path: "/", expires: Time.now+24*60*60
      elsif request.path == "/"
        response.delete_cookie "requested_page"
      end
      response.finish
    end
  end
end

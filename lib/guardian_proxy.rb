require "rack-proxy"
require "zlib"

class GuardianProxy < Rack::Proxy
  def initialize app
    @app = app
  end

  def call env
    request = Rack::Request.new env
    if request.path =~ %r{^/crosswords}
      super
    else
      @app.call env
    end
  end

  def rewrite_env env
    env["HTTP_HOST"] = "www.guardian.co.uk"
    env["SERVER_PORT"] = 80
    env
  end

  def rewrite_response triplet
    status, headers, body = triplet
    raw_body = if headers["content-encoding"] == "gzip"
                 Zlib::GzipReader.new(StringIO.new(body.to_s),
                                      :external_encoding => body.to_s.encoding).read
               else
                 body
               end
    new_body = raw_body.to_s.gsub("http://www.guardian.co.uk/crosswords/", "#{BASE_URL}/crosswords/"
                                 ).sub("</body>", %{<script src="/assets/js/application.js"></script></body>})
    headers["Content-Length"] = new_body.length.to_s
    headers.delete "content-encoding"
    headers.delete "transfer-encoding"
    [status, headers, [new_body]]
  end
end

class TestRackContext
  include FlipFab::Helper

  attr_reader :request, :response

  def initialize cookies, host
    @request  = Rack::Request.new({ 'HTTP_COOKIE' => cookies, 'HTTP_HOST' => host })
    @response = Rack::Response.new
    request.cookies.each{|k,v| response.set_cookie k, v }
  end

  def response_cookies
    response.header['Set-Cookie']
  end
end

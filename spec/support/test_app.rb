class TestApp
  include FlipFab::Helper

  attr_reader :request, :response, :params, :contextual_features

  def call(env)
    @request  = Rack::Request.new env
    @response = Rack::Response.new
    @params   = request.params

    @contextual_features = features

    request.cookies.each { |k, v| response.set_cookie k, v }
    [response.status, response.header, response.body]
  end
end

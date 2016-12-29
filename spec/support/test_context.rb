class TestContext
  include FlipFab::Helper

  attr_reader :feature_states, :params

  def initialize(feature_states = {}, params = {})
    @feature_states = feature_states
    @params         = params
  end
end

class TestContext
  include FlipFab::Helper

  attr_reader :feature_states

  def initialize feature_states={}
    @feature_states = feature_states
  end
end

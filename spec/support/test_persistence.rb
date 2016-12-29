class TestPersistence < FlipFab::Persistence
  def initialize(feature_name, context)
    super
  end

  def read
    context.feature_states[feature_name]
  end

  def write(state)
    context.feature_states[feature_name] = state
  end
end

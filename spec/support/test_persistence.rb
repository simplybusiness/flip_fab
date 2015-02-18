class TestPersistence < FlipFab::Persistence

  def initialize feature_name, context
    super
  end

  def read
    context.feature_states[feature_name]
  end

  def write value
    context.feature_states[feature_name] = value
  end
end

class TestMultiplePersistence < FlipFab::Persistence
  def initialize(feature_name, context)
    super
  end

  def read
    context.feature_states[:different_example_feature]
  end

  def write(value)
    context.feature_states[:different_example_feature] = value
  end
end

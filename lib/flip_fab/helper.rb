module FlipFab
  module Helper
    def features(feature_context = self)
      @features ||= FlipFab.features.with_context feature_context
    end
  end
end

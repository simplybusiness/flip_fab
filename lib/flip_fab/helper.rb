module FlipFab
  module Helper

    def features
      @features ||= FeaturesByName.new Hash[FlipFab.features.map{|name, feature| [name, (ContextualFeature.new feature, self )]}]
    end
  end
end

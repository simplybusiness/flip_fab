module FlipFab
  module Helper

    def features
      @features ||= FlipFab.features.with_context self
    end
  end
end

module FlipFab
  class Feature
    attr_reader :name, :default, :persistence_adapters

    def initialize(name, options = {})
      @name                 = name
      @default              = options[:default] || :disabled
      @persistence_adapters = options[:persistence_adapters] || [CookiePersistence]
    end

    def enabled?
      default == :enabled
    end

    def disabled?
      !enabled?
    end

    def with_context(context)
      ContextualFeature.new self, context
    end
  end
end

module FlipFab
  class Feature

    attr_reader :name, :default, :persistence_adapters

    def initialize name, options
      @name                 = name
      @default              = options[:default] || :disabled
      @persistence_adapters = options[:persistence_adapters] || []
    end

    def enabled?
      default == :enabled
    end

    def disabled?
      !enabled?
    end
  end
end
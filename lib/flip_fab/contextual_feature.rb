module FlipFab
  class ContextualFeature
    attr_reader :feature, :context, :override

    def initialize feature, context, override=nil
      @feature  = feature
      @context  = context
      @override = override
      if overridden?
        @state = override
        persist
      end
    end

    def enabled?
      state == :enabled
    end

    def disabled?
      !enabled?
    end

    def enable
      unless_overridden do
        @state = :enabled
        persist
      end
    end

    def disable
      unless_overridden do
        @state = :disabled
        persist
      end
    end

    def persist
      persistence_adapters.each{ |adapter| adapter.write state }
    end

    def overridden?
      !override.nil?
    end

    private

    def persistence_adapters
      @persistence_adapters ||= feature.persistence_adapters.map { |adapter_class| adapter_class.new feature.name, context }
    end

    def state
      @state ||= if in_context?
        state_from_context
      else
        default_state
      end
    end

    def in_context?
      !first_adapter_with_state.nil?
    end

    def state_from_context
      first_adapter_with_state.read
    end

    def first_adapter_with_state
      persistence_adapters.detect{|adapter| !adapter.read.nil?}
    end

    def default_state
      feature.default
    end

    def unless_overridden &block
      block.call unless overridden?
    end
  end
end

module FlipFab
  class ContextualFeature
    attr_reader :feature, :context

    def initialize feature, context
      @feature = feature
      @context = context
    end

    def enabled?
      state == :enabled
    end

    def disabled?
      !enabled?
    end

    def enable; end

    def disable; end

    def persist; end

    private

    def persistence_adapters
      feature.persistence_adapters.map { |adapter_class| adapter_class.new feature.name, context }
    end

    def state
      if in_context?
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
  end
end

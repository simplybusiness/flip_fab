module FlipFab
  class Persistence

    attr_reader :feature_name, :context

    def initialize feature_name, context
      @feature_name = feature_name
      @context      = context
    end

    def read
      raise NotSupportedException
    end

    def write value
      raise NotSupportedException
    end
  end
end

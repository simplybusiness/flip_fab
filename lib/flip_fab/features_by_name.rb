require 'forwardable'

module FlipFab
  class FeaturesByName
    extend Forwardable

    def initialize(features_by_name = {})
      @features_by_name = features_by_name
    end

    def [](name)
      raise "no feature has been defined with the name: #{name}" if @features_by_name[name].nil?

      @features_by_name[name]
    end

    def with_context(context)
      FeaturesByName.new Hash[@features_by_name.map { |name, feature| [name, (feature.with_context context)] }]
    end

    def_delegators :@features_by_name, :[]=, :clear, :count, :each
  end
end

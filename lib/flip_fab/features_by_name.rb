require 'forwardable'

module FlipFab
  class FeaturesByName
    extend Forwardable

    def initialize features_by_name={}
      @features_by_name = features_by_name
    end

    def [] name
      raise "no feature has been defined with the name: #{name}" if @features_by_name[name].nil?
      @features_by_name[name]
    end

    def_delegators :@features_by_name, :[]=, :clear, :map, :count
  end
end

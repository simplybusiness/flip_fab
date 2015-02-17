require 'flip_fab/contextual_feature'
require 'flip_fab/feature'
require 'flip_fab/persistence'

module FlipFab
  extend self

  attr_reader :features

  def define_feature name, options={}
    @features ||= {}
    @features[name] = Feature.new name, options
  end
end

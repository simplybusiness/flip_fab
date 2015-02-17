require 'flip_fab/cookie_adapter'
require 'flip_fab/contextual_feature'
require 'flip_fab/feature'

module FlipFab
  extend self

  attr_reader :features

  def define_feature name, options={}
    @features ||= {}
    @features[name] = Feature.new name, options
  end
end

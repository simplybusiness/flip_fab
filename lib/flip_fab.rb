require 'flip_fab/contextual_feature'
require 'flip_fab/features_by_name'
require 'flip_fab/feature'
require 'flip_fab/helper'
require 'flip_fab/persistence'

module FlipFab
  extend self

  attr_reader :features

  def define_feature name, options={}
    @features ||= {}
    @features[name] = Feature.new name, options
  end

  @features ||= FeaturesByName.new
end

if defined?(ActionController)
  ActionController::Base.send :include, FlipFab::Helper
  ActionController::Base.helper FlipFab::Helper
end

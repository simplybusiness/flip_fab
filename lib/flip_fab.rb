require 'flip_fab/contextual_feature'
require 'flip_fab/helper'
require 'flip_fab/feature'
require 'flip_fab/persistence'
require 'flip_fab/cookie_persistence'

module FlipFab
  extend self

  attr_reader :features

  def define_feature name, options={}
    @features ||= {}
    @features[name] = Feature.new name, options
  end
end

if defined?(ActionController)
  ActionController::Base.send :include, FlipFab::Helper
  ActionController::Base.helper FlipFab::Helper
end

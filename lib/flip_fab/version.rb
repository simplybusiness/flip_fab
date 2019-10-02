module FlipFab
  VERSION = '1.0.5' # rubocop:disable Style/MutableConstant

  # SB-specific versioning "algorithm" to accommodate BNW/Jenkins/gemstash
  VERSION << '.' << ENV['GEM_PRE_RELEASE'].strip \
  unless ENV.fetch('GEM_PRE_RELEASE', '').strip.empty?
end

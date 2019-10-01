module FlipFab
  GEM_VERSION = '1.0.5'.freeze

  # SB-specific versioning "algorithm" to accommodate BNW/Jenkins/gemstash
  VERSION = if ENV.fetch('GEM_PRE_RELEASE', '').strip.empty?
              GEM_VERSION
            else
              "#{GEM_VERSION}.#{ENV['GEM_PRE_RELEASE'].strip}"
            end
end

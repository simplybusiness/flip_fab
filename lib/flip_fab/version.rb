module FlipFab
  GEM_VERSION = '1.0.4'.freeze

  # SB-specific versioning "algorithm" to accomodate Jenkins / gemstash
  VERSION = if ENV['GEM_PRE_RELEASE'].nil? || ENV['GEM_PRE_RELEASE'].empty?
                  FlipFab::GEM_VERSION
                else
                  "#{FlipFab::GEM_VERSION}.#{ENV['GEM_PRE_RELEASE']}"
                end
end

# frozen_string_literal: true

module FlipFab
  base = '1.1.21'

  # SB-specific versioning "algorithm" to accommodate BNW/Jenkins/gemstash
  VERSION = (pre = ENV.fetch('GEM_PRE_RELEASE', '')).empty? ? base : "#{base}.#{pre}"
end

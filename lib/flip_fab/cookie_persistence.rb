module FlipFab
  class CookiePersistence < FlipFab::Persistence
    COOKIE_PATH = '/'.freeze
    COOKIE_DURATION_MONTHS = 12
    # See: https://github.com/rails/rails/blob/b1124a2ac88778c0feb0157ac09367cbd204bf01/actionpack/lib/action_dispatch/middleware/cookies.rb#L214
    DOMAIN_REGEXP          = /[^.]*\.([^.]*|..\...|...\...)$/

    def initialize(feature_name, context)
      super
    end

    def read
      value.to_sym unless value.nil?
    end

    def write(state)
      cookie_domain = ".#{top_level_domain}" unless top_level_domain.nil?
      context.response.set_cookie key, value:   state,
                                       expires: cookie_expiration,
                                       path:    COOKIE_PATH
    end

    private

    def key
      "flip_fab.#{feature_name}"
    end

    def value
      @value ||= context.request.cookies[key]
    end

    # See: https://github.com/rails/rails/blob/b1124a2ac88778c0feb0157ac09367cbd204bf01/actionpack/lib/action_dispatch/middleware/cookies.rb#L286-L294
    def top_level_domain
      $& if (host !~ /^[\d.]+$/) && (host =~ DOMAIN_REGEXP)
    end

    def cookie_expiration
      (Time.now.utc.to_datetime >> COOKIE_DURATION_MONTHS).to_time
    end

    def host
      context.request.host
    end
  end
end

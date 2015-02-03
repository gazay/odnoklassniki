require 'digest/md5'

module Odnoklassniki
  class Client < Weary::Client
    OAUTH_PARAM_NAMES = [:token,
                         :refresh_token,
                         :client_id,
                         :client_secret,
                         :application_key].freeze

    domain 'http://api.odnoklassniki.ru/fb.do'

    user_agent "Odnoklassniki API Client (Ruby)/#{Odnoklassniki::VERSION} (+http://github.com/gazay/odnoklassniki)"

    def initialize(oauth_params = {})
      @defaults = {}
      OAUTH_PARAM_NAMES.each do |param|
        @defaults[param] = hash_fetch(params, param)
      end
    end

    private

    def hash_fetch(hash, key)
      hash[key] || hash[key.to_s]
    end

  end
end

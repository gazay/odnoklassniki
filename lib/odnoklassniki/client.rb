require 'weary'
require 'digest/md5'

module Odnoklassniki
  class Client < Weary::Client
    OAUTH_PARAM_NAMES = [:access_token,
                         :refresh_token,
                         :client_id,
                         :client_secret,
                         :application_key].freeze

    domain 'http://api.odnoklassniki.ru/api'

    user_agent "Odnoklassniki API Client (Ruby)/#{Odnoklassniki::VERSION} (+http://github.com/gazay/odnoklassniki)"

    get :current_user, '/users/getCurrentUser' do |r|
      r.required :access_token, :application_key
      r.optional :fields
    end

    def initialize(params = {})
      @defaults = {}
      OAUTH_PARAM_NAMES.each do |param|
        @defaults[param] = hash_fetch(params, param)
      end
    end

    private

    def refresh_token!
    end

    def hash_fetch(hash, key)
      hash[key] || hash[key.to_s]
    end

  end
end

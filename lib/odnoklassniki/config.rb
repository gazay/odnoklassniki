module Odnoklassniki
  module Config

    VALID_OPTIONS_KEYS = [:access_token,
                          :refresh_token,
                          :client_id,
                          :client_secret,
                          :application_key].freeze

    attr_accessor *VALID_OPTIONS_KEYS

    def configure
      yield self
      self
    end

    def options
      options = {}
      VALID_OPTIONS_KEYS.each{ |pname| options[pname] = send(pname) }
      options
    end

    def credentials
      {
        :application_key => application_key,
        :client_secret => consumer_secret,
        :access_token => access_token
      }
    end

  end
end

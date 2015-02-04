module Odnoklassniki
  class Config

    VALID_OPTIONS_KEYS = [:access_token,
                          :client_id,
                          :client_secret,
                          :application_key].freeze

    attr_accessor *VALID_OPTIONS_KEYS

    def self.configure
      config = self.new
      yield config
      config
    end

    def initialize(options={})
      @access_token = options[:access_token] || options['access_token']
      @client_id = options[:client_id] || options['client_id']
      @client_secret = options[:client_secret] || options['client_secret']
      @application_key = options[:application_key] || options['application_key']
    end

    def options
      options = {}
      VALID_OPTIONS_KEYS.each{ |pname| options[pname] = send(pname) }
      options
    end

  end
end

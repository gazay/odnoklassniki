require 'odnoklassniki/error'
require 'odnoklassniki/utils'
require 'odnoklassniki/version'

module Odnoklassniki
  class Client
    include Odnoklassniki::Utils
    attr_accessor :access_token, :refresh_token,
                  :application_id, :application_key, :application_secret
    attr_writer :user_agent

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [Odnoklassniki::Client]
    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    # @return [Boolean]
    def user_token?
      !!(access_token && refresh_token)
    end

    # @return [String]
    def user_agent
      @user_agent ||= "OdnoklassnikiRubyGem/#{Odnoklassniki::Version}"
    end

    # @return [Hash]
    def credentials
      {
        consumer_key: consumer_key,
        consumer_secret: consumer_secret,
        token: access_token,
        token_secret: access_token_secret,
      }
    end

    # @return [Boolean]
    def credentials?
      credentials.values.all?
    end

    # @return [String]
    def signature
    end

    # @return [String]
    def renew_token
    end
  end
end

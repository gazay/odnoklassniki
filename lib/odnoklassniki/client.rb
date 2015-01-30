require 'odnoklassniki/error'
require 'odnoklassniki/version'

require 'multi_json'
require 'digest/md5'

module Odnoklassniki
  class Client
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
        token: access_token,
        refresh_token: refresh_token,
        client_id: appication_id,
        client_secret: application_secret,
        application_key: application_key
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

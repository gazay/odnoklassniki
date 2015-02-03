require 'odnoklassniki/user'
require 'odnoklassniki/request'
require 'odnoklassniki/connection'
# require 'odnoklassniki/post'
require 'odnoklassniki/helpers'

module Odnoklassniki
  class Client

    include Odnoklassniki::User
    # include Odnoklassniki::Post
    include Odnoklassniki::Helper

    def initialize(attrs= {})
      attrs = Odnoklassniki.options.merge(attrs)
      Config::VALID_OPTIONS_KEYS.each do |key|
        instance_variable_set("@#{key}".to_sym, attrs[key])
      end
    end

    def get(path, params={})
      request.get(path, params)
    end

    def post(path, params={})
      request.post(path, params)
    end

    def credentials
      {
        application_key: @application_key,
        client_secret: @client_secret,
        access_token: @access_token
      }
    end

    private

    def request
      @request ||= Request.new
    end

  end
end

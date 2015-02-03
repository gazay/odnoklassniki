require 'odnoklassniki/request'

module Odnoklassniki
  class Client

    def initialize(attrs= {})
      attrs = Odnoklassniki.options.merge(attrs)
      Config::VALID_OPTIONS_KEYS.each do |key|
        instance_variable_set("@#{key}".to_sym, attrs[key])
      end
      @refreshed = false
    end

    def get(method, params={})
      request.get(method_path(method), params)
    end

    def post(method, params={})
      request.post(method_path(method), params)
    end

    def refresh_token!
      data = request.post('/oauth/token.do', refresh_credentials)
      @request = nil
      @refreshed = true
      @access_token = data['access_token']
    end

    private

    def method_path(method)
      if method.start_with?('api')
        "/#{method}"
      elsif method.start_with?('/api')
        method
      elsif method.start_with?('/')
        "/api#{method}"
      else
        "/api/#{method}"
      end.gsub('.', '/')
    end

    def refresh_credentials
      {
        refresh_token: @access_token,
        grant_type:    'refresh_token',
        client_id:     @client_id,
        client_secret: @client_secret
      }
    end

    def request
      refresh_token! unless @refreshed
      @request ||= Request.new(credentials)
    end

    def credentials
      {
        access_token:    @access_token,
        client_secret:   @client_secret,
        application_key: @application_key
      }
    end

  end
end

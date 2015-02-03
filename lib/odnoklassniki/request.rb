require 'odnoklassniki/connection'
require 'multi_json'

module Odnoklassniki
  class Request

    include Odnoklassniki::Connection

    def initialize(credentials)
      @access_token    = credentials[:access_token]
      @client_secret   = credentials[:client_secret]
      @application_key = credentials[:application_key]
    end

    # Perform a get request and return the raw response
    def get_response(path, params = {})
      connection.get do |req|
        req.url path
        req.params = params
      end
    end

    # get a redirect url
    def get_redirect_url(path, params = {})
      response = get_response path, params
      if response.status == 301
        response.headers['Location']
      else
        response.body['meta']
      end
    end

    # Performs a get request
    def get(path, params={})
      respond get_response(path, signed(params))
    end

    # Performs post request
    def post(path, params={})
      response = connection.post do |req|
        req.url path
        req.body = signed(params) unless params.empty?
      end
      #Check for errors and encapsulate
      respond(response)
    end

    private

    def respond(response)
      if [201, 200].include?(response.status)
        response.body
      else
        raise StandardError.new response.inspect
      end
    end

    def signed(params)
      params = params.merge(application_key: @application_key)
      params.merge(sig: signature(params), access_token: @access_token)
    end

    def signature(params)
      sorted_concatenated_params =
        Hash[params.sort].map { |k, v| "#{k}=#{v}" }.join
      secret_part = Digest::MD5.hexdigest("#{@access_token}#{@client_secret}")
      Digest::MD5.hexdigest("#{sorted_concatenated_params}#{secret_part}")
    end

  end
end

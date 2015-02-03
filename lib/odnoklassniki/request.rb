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
      parsed_body = \
        begin
          MultiJson.load(body)
        rescue MultiJson::DecodeError
          #Есть случаи отдачи кривого JSON от одноклассников
          gsubed = body.
                     gsub(/[^"]}/, '"}').
                     gsub(/([^"}]),"([^}])/, '\1","\2')
          MultiJson.load(gsubed)
        end

      fail_or_return_body(response.status, parsed_body)
    rescue MultiJson::DecodeError => e
      raise Odnoklassniki::Error::ClientError.new(e.message)
    end

    def fail_or_return_body(code, body)
      error = error(code, body)
      fail(error) if error
      body
    end

    def error(code, body)
      if ![200, 201].include?(code)
        if klass = Odnoklassniki::Error::ERRORS[code]
          klass.from_response(body)
        end
      else
        if body.is_a?(Hash) && body['error_code']
          Odnoklassniki::Error::ClientError.from_response(body)
        end
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

require_relative 'connection'
require 'multi_json'

module Odnoklassniki
  class Request

    include Odnoklassniki::Connection

    def initialize(credentials)
      @access_token    = credentials[:access_token]
      @client_secret   = credentials[:client_secret]
      @application_key = credentials[:application_key]
    end

    # Performs a get request
    def get(path, params={})
      respond perform_request(:get, path, params)
    end

    # Performs post request
    def post(path, params={})
      respond perform_request(:post, path, params)
    end

    private

    def perform_request(method, path, params)
      signed_params = signed params

      connection.send(method) do |req|
        req.url path
        if method == :get
          req.params = signed_params
        else
          req.body = signed_params unless params.empty?
        end
      end
    end

    def respond(response)
      parsed_body = \
        begin
          MultiJson.load(response.body)
        rescue MultiJson::DecodeError
          #Есть случаи отдачи кривого JSON от одноклассников
          gsubed = response.body.
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

require 'weary/request'
require 'weary/middleware'

module Odnoklassniki
  class Authentication
    HOST = 'http://api.odnoklassniki.ru/oauth'

    def refresh_token(token, client_id, client_secret)
      Weary::Request.new "#{HOST}/token.do", :POST do |req|
        req.use Weary::Middleware::OAuth, :refresh_token => token,
                                          :client_id => client_id,
                                          :client_secret => client_secret
      end
    end
  end
end

module Odnoklassniki
  module REST
    class User

      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def current_user(fields=[])
        options = fields.empty? ? {} : fiels.join(',')
        client.get('users.getCurrentUser', options)
      end

    end
  end
end

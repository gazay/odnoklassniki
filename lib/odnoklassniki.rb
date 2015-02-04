require_relative 'odnoklassniki/error'
require_relative 'odnoklassniki/version'
require_relative 'odnoklassniki/client'
require_relative 'odnoklassniki/config'

module Odnoklassniki
  extend Config

  class << self
    def new(options = {})
      Odnoklassniki::Client.new(options)
    end
  end
end

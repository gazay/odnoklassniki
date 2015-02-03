require 'odnoklassniki/error'
require 'odnoklassniki/version'
require 'odnoklassniki/client'
require 'odnoklassniki/config'

module Odnoklassniki
  extend Config

  class << self
    def new(options = {})
      Odnoklassniki::Client.new(options)
    end
  end
end

DNO = Odnoklassniki

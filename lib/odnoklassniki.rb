require_relative 'odnoklassniki/error'
require_relative 'odnoklassniki/version'
require_relative 'odnoklassniki/client'
require_relative 'odnoklassniki/config'

module Odnoklassniki

  class << self
    attr_accessor :config

    def new(options = {})
      Odnoklassniki::Client.new(options)
    end

    def configure
      @config = Odnoklassniki::Config.new
      yield @config
      @config
    end

    def options
      (@config && @config.options) || {}
    end

  end

end

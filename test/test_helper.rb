if ENV['COV'] == '1'
  require 'simplecov'
  SimpleCov.start
end

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative '../lib/odnoklassniki'

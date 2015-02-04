if ENV['COV'] == '1'
  require 'simplecov'
  SimpleCov.start
end

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = "test/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end

require_relative '../lib/odnoklassniki'

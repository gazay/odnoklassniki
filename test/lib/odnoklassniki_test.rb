require_relative '../test_helper'

class TestOdnoklassniki < Minitest::Test

  def setup
    @options = {
      access_token: '1',
      client_id: '2',
      client_secret: '3',
      application_key: '4'
    }
    Odnoklassniki.configure do |c|
      @options.each { |k, v| c.send("#{k}=", v) }
    end
  end

  def test_new
    assert_instance_of Odnoklassniki::Client, Odnoklassniki.new
  end

  def test_configure
    assert_equal Odnoklassniki::Client.new.instance_variable_get(:@access_token), '1'
  end

  def test_options
    assert_equal Odnoklassniki.options, @options
  end

end

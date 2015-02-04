require_relative '../../test_helper'

class TestOdnoklassnikiConfig < Minitest::Test

  def setup
    @options = {
      access_token: '1',
      client_id: '2',
      client_secret: '3',
      application_key: '4'
    }
  end

  def test_configure
    config = Odnoklassniki::Config.configure do |c|
      @options.each do |k, v|
        c.send("#{k}=", v)
      end
    end
    assert_equal config.options, @options
  end

  def test_new
    config = Odnoklassniki::Config.new(@options)
    assert_equal config.options, @options
  end

  def test_options
    opts = @options.merge({some_unused_key: 123})
    config = Odnoklassniki::Config.new(opts)
    assert_equal config.options, @options
  end

end

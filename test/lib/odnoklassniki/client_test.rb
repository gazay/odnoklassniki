require_relative '../../test_helper'

class TestOdnoklassnikiClient < Minitest::Test

  def setup
    @client = Odnoklassniki::Client.new({
      access_token: 'token',
      client_id: 'client_id',
      client_secret: 'client_secret',
      application_key: 'application_key'
    })
  end

  def test_get_with_wrong_credentials
    VCR.use_cassette('client_wrong_credentials_getCurrentUser') do
      error = assert_raises Odnoklassniki::Error::ClientError do
        @client.instance_variable_set(:@refreshed, true)
        @client.get('users.getCurrentUser')
      end
      assert_equal 'PARAM_API_KEY : Application not exist', error.message
      assert_equal 101, error.code
    end
  end

  def test_post_with_wrong_credentials
    VCR.use_cassette('client_wrong_credentials_post') do
      error = assert_raises Odnoklassniki::Error::ClientError do
        @client.instance_variable_set(:@refreshed, true)
        @client.post('mediatopic.post')
      end
      assert_match /No application key/, error.message
      assert_equal 101, error.code
    end
  end

  def test_refresh_token_with_wrong_credentials
    VCR.use_cassette('client_wrong_credentials_token') do
      error = assert_raises Odnoklassniki::Error::ClientError do
        @client.refresh_token!
      end
      assert_equal nil, error.code
    end
  end

end

require_relative '../../test_helper'

class TestOdnoklassnikiRequest < Minitest::Test

  def setup
    @request = Odnoklassniki::Request.new({
      access_token: 'token',
      client_secret: 'client_secret',
      application_key: 'application_key'
    })
  end

  def test_get_with_wrong_credentials
    VCR.use_cassette('wrong_credentials_getCurrentUser') do
      error = assert_raises Odnoklassniki::Error::ClientError do
        @request.get('/api/users/getCurrentUser')
      end
      assert_equal 'PARAM_API_KEY : Application not exist', error.message
      assert_equal 101, error.code
    end
  end

  def test_post_with_wrong_credentials
    VCR.use_cassette('wrong_credentials_token') do
      error = assert_raises Odnoklassniki::Error::ClientError do
        @request.post('/oauth/token.do')
      end
      assert_match /Provide OAUTH request parameters!/, error.message
      assert_equal error.code, nil
    end
  end

end

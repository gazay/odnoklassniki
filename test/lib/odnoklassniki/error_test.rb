require_relative '../../test_helper'

class TestOdnoklassnikiError < Minitest::Test

  def test_from_response
    error = Odnoklassniki::Error.
      from_response({ 'error_msg' => 'message', 'error_code' => 123 })
    assert_instance_of Odnoklassniki::Error, error
    assert_equal error.code, 123
    assert_equal error.message, 'message'
  end

end

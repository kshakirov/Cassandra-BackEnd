require_relative "../test_helper"
class TestAdmin < Minitest::Test

  def setup
    @admin_controller =TurboCassandra::Controller::Admin.new
  end

  def test_change_forgotten_password
    new_password = @admin_controller.reset_password("kirill.shakirov4@gmail.com")
    refute_nil new_password
    assert new_password[:result]
    assert new_password[:password].size >= 10
  end

  def test_create_new_customer
    response  = @admin_controller.create_new_customer({'email' => 'kshakirov@zoral.com.ua'})
    refute_nil response
    assert_equal(response['action'], 'new')
  end

end
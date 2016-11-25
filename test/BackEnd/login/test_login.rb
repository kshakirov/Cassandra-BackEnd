require_relative "test_helper"
class TestProduct < Minitest::Test
  def setup
    @login_manager = TurboCassandra::Login.new
  end

  def test_non_ti_interchange
    @login_manager.validate_password 'servantes1', 'kshakirov@zoral.com.ua'
  end

  def test_ti_manufactured
    assert @login_manager.validate_customer 'gogol', 'kshakirov@zoral.com.ua'

  end
end








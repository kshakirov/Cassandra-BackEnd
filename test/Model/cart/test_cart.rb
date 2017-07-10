require_relative '../test_helper'

class TestCartModel < Minitest::Test

  def test_load
    cart  = TurboCassandra::Model::Cart.find 487
    assert_equal cart.id, 487
  end

end


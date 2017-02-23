require '../test_helper'

class TestCartModel < Minitest::Test
  def setup
    @cart_model = TurboCassandra::Model::Cart.new
  end
  def test_insert
    items  = @cart_model.count_items(632)
    assert_true 2, items
  end



end


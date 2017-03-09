require_relative "../test_helper"
class TestCart < Minitest::Test

  def setup
    @cart_model = TurboCassandra::Model::Cart.new
    @product_controller = TurboCassandra::Controller::Product.new
  end

  def test_find
    cart = @cart_model.find 12
    refute_nil  cart
  end

  def test_add_item
    product = @product_controller.get_product 1
    @cart_model.add_product 12, product, 74.8, 2
    count  = @cart_model.count_items(12)
    assert_equal 2, count.to_i

  end

  def test_delete_item
      @cart_model.delete_item 487, 41661
  end

end
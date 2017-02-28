require_relative "../test_helper"
class TestCart < Minitest::Test

  def setup
    @cart_model = TurboCassandra::Model::Cart.new
    @product_controller = TurboCassandra::Controller::Product.new
  end

  def test_find
    cart = @cart_model.find 487
    refute_nil  cart
  end

  def test_add_item
    @cart_model.delete_product 487, 1
    product = @product_controller.get_product 1
    @cart_model.add_product 487, product, 74.8, 2
    count  = @cart_model.count_items(487)
    assert_equal 2, count

  end

  def test_delete_item
      @cart_model.delete_item 487, 41661
  end

end
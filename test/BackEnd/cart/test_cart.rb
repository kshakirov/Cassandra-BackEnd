require_relative "test_helper"
class TestCart < Minitest::Test

  def setup
    @cart_model = TurboCassandra::CartBackEnd.new
    @product_model = TurboCassandra::ProductBackEnd.new
  end

  def test_find
    cart = @cart_model.find 487
    cart  = JSON.parse cart
    p cart
  end

  def test_add_item
    product = @product_model.get_product 41661
    product = JSON.parse product
    @cart_model.add_item 487, product, 74.8, 2
  end

  def test_delete_item
      @cart_model.delete_item 487, 41661
  end

end
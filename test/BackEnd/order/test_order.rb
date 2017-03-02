require_relative "../test_helper"
class TestOrder < Minitest::Test

  def setup
    @order_controler = TurboCassandra::Controller::Order.new
    @order_api = TurboCassandra::API::Order.new
  end

  def test_load_order
    order = @order_controler.get_order_by_customer_id 24
    refute_nil order
  end

  def test_create_order
    order = @order_controler.create_order 12
    assert order
  end

  def test_next_id
    id  = @order_controler.save 12, {}
    assert id
  end

  def test_also_bought
    products  = @order_controler.get_also_bought_products('42784')
    refute_nil products
  end

  def test_order_product_insert
    order = @order_controler.get_order_by_customer_id 24
    @order_api.register_order_product(order.first)
  end

  def test_product_order_insert
    order = @order_controler.get_order_by_customer_id 24
    @order_api.register_product_order(order.first)
  end

  def test_get_also_bought_product
    products  = @order_api.get_also_bought_products 43782
    refute_nil products
  end



end


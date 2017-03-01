require_relative "../test_helper"
class TestOrder < Minitest::Test

  def setup
    @order_controler = TurboCassandra::Controller::Order.new
  end

  def test_load_order
    order = @order_controler.get_order_by_customer_id 12
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
end


require_relative "test_helper"
class TestOrder < Minitest::Test

  def setup
    @order_model = TurboCassandra::OrderBackEnd.new
  end

  def test_load_order
    order = @order_model.get_order_by_customer_id '487'
    order = JSON.parse order
    p order
  end

  def test_create_order
    order = @order_model.create_order 487
    assert true
  end

  def test_next_id
    id  = @order_model.save 1, {}
    p id
  end
end


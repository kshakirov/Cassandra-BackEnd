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
end


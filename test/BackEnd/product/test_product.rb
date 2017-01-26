require_relative "test_helper"
class TestProduct < Minitest::Test

  def setup
    @order_model = TurboCassandra::ProductBackEnd.new
  end

  def test_non_ti_interchange
    pr = @order_model.get_product 6228
    pr = JSON.parse pr
    p pr
  end

  def test_ti_manufactured

    pr = @order_model.get_product 44652
    pr = JSON.parse pr
    p pr
  end
end


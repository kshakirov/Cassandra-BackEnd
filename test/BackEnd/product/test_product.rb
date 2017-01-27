require_relative "test_helper"
class TestProduct < Minitest::Test

  def setup
    @product_model = TurboCassandra::ProductBackEnd.new
  end

  def test_non_ti_interchange
    pr = @product_model.get_product 6228
    pr = JSON.parse pr
    p pr
  end

  def test_ti_manufactured

    pr = @product_model.get_product 44652
    pr = JSON.parse pr
    p pr
  end

  def test_get_products
    prs = @product_model.get_products [44652,6228]
    p prs
  end

end


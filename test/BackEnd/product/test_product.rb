require_relative "../test_helper"

class TestProduct < Minitest::Test

  def setup
    @product_model = TurboCassandra::ProductBackEnd.new
  end

  def test_get_products
    prs = @product_model.get_products [62923,65019]
    refute_nil prs
  end

  def test_get_product
    prs = @product_model.get_product 62923
    refute_nil prs
  end

end


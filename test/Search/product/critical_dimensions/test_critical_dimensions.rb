require_relative "../test_helper"
class TestCriticalDims < Minitest::Test
  def setup
    @product = TurboCassandra::API::Product.new
    @product_transformer = TurboCassandra::EsProductTransformer.new
  end

  def test_all_critical
    p = @product.find_by_sku  46073
    refute_nil p
    elastic_product = @product_transformer.run  p
    refute_nil elastic_product
  end


end
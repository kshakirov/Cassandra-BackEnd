require_relative "../test_helper"
class TestTiChra < Minitest::Test
  def setup
    @product_api = TurboCassandra::API::Product.new
    @product_transformer = TurboCassandra::EsProductTransformer.new
  end

  def test_ti_chra
    product = @product_api.find_by_sku 68157
    refute_nil product
    elastic_product = @product_transformer.get_ti_chra product
    refute_nil elastic_product
    assert_equal '1-D-3573',  elastic_product.first[:part_number]
  end

  def test_foreign_chra
    product = @product_api.find_by_sku 19191
    refute_nil product
    elastic_product = @product_transformer.get_foreign_chra product
    refute_nil elastic_product
    assert_equal '5303-710-0509',   elastic_product.first[:part_number]
  end


end

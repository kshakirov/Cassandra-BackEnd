require_relative "../test_helper"
class TestOeRefUrl < Minitest::Test
  def setup
    @product = TurboCassandra::API::Product.new
    @product_transformer = TurboCassandra::EsProductTransformer.new
  end


  def test_ti_oe_ref_2
    product = @product.find_by_sku  6307
    refute_nil product
    elastic_product = @product_transformer.run product
    refute_nil elastic_product
    assert_nil   elastic_product['oe_ref_urls']
  end

  def test_ti_oe_ref_not_ext
    product = @product.find_by_sku  30160
    refute_nil product
    elastic_product = @product_transformer.run product
    refute_nil elastic_product
    assert_equal  '078145703H', elastic_product['oe_ref_urls'][:part_number]
  end
end


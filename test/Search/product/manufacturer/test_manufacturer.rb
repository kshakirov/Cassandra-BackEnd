require_relative "../test_helper"
class TestInterchange < Minitest::Test
  def setup
    @product = TurboCassandra::API::Product.new
    tcas_host = get_tcas_host
    @product_transformer = TurboCassandra::EsProductTransformer.new(tcas_host)
  end

  def test_non_ti_interchange
    p = @product.find_by_sku  43747
    refute_nil p
    elastic_product = @product_transformer.run p
    assert_equal elastic_product['manufacturer'][0][:name], 'Turbo International'
  end
end
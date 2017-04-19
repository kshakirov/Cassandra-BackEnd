require_relative "../test_helper"
class TestProductIndexe < Minitest::Test
  def setup
    @product = TurboCassandra::API::Product.new
    elastic_host = get_elastic_host
    @product_indexer = TurboCassandra::ElasticIndex.new(elastic_host)
  end

  def test_delete
    response  = @product_indexer.delete 48225
    refute_nil response
  end

  def test_add_ti
    product  = @product.find_by_sku 54018
    response  = @product_indexer.add_product product
    refute_nil response
  end

  def test_add_not_external
    product = @product.find_by_sku  48228
    response  = @product_indexer.add_product product
    refute_nil response
  end

  def test_search
    product  = @product_indexer.get 48225
    refute_nil product
  end
end
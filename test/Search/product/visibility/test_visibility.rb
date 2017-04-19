require_relative "../test_helper"

class TestVisibility < Minitest::Test
  def setup
    @product_api = TurboCassandra::API::Product.new
    @product_transformer = TurboCassandra::EsProductTransformer.new
  end

  def test_not_turbo
    product = @product_api.find_by_sku 44765
    elastiic_product = @product_transformer.run(product)
    assert elastiic_product['visible_in_catalog']
  end

  def test_not_turbo_2
    product = @product_api.find_by_sku 5636
    elastiic_product = @product_transformer.run(product)
    assert_equal false, elastiic_product['visible_in_catalog']
  end

  def test_turbo_without_ti_chra
    product = @product_api.find_by_sku 6700
    elastiic_product = @product_transformer.run(product)
    assert_equal false, elastiic_product['visible_in_catalog']
  end

  def test_turbo_with_ti_chra
    product = @product_api.find_by_sku 19191
    elastiic_product = @product_transformer.run(product)
    assert_equal true, elastiic_product['visible_in_catalog']
  end

  def test_ti_chra_not_external
    product = @product_api.find_by_sku 67802
    elastiic_product = @product_transformer.run(product)
    assert_equal false, elastiic_product['visible_in_catalog']
  end
end
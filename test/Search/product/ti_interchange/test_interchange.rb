require_relative "../test_helper"
class TestInterchange < Minitest::Test
  def setup
    @product_api = TurboCassandra::API::Product.new
    @product_transformer = TurboCassandra::EsProductTransformer.new
  end

  def test_external_manufacturer
    product = @product_api.find_by_sku 44758
    elastic_product = @product_transformer.run product
    refute_nil elastic_product
    assert_equal '5-A-0718', elastic_product[:ti_part][:ti_part_number]

  end

  def test_external_manufacturer_yes
    product = @product_api.find_by_sku 45070
    elastic_product = @product_transformer.run product
    refute_nil elastic_product
  end

  def test_external_manufacturer_no
    product = @product_api.find_by_sku 30160
    elastic_product = @product_transformer.run product
    refute_nil elastic_product
  end

  def test_ti_interchanges
    product = @product_api.find_by_sku  64394
    elastic_product = @product_transformer.run product
    refute_nil elastic_product

  end


end


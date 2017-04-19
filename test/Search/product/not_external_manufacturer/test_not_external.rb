require_relative "../test_helper"
class TestNotExternalManufacturer < Minitest::Test
  def setup
    @product = TurboCassandra::API::Product.new
    @product_transformer = TurboCassandra::EsProductTransformer.new
  end



  def test_oe_ref
    product = @product.find_by_sku  43936
    refute_nil product
    elastic_product = @product_transformer.run product
    refute_nil elastic_product
    assert_equal elastic_product['visible_in_catalog'], false

  end


  def test_turbo
    product = @product.find_by_sku  13445
    refute_nil product
    elastic_product = @product_transformer.run product
    refute_nil elastic_product
    assert_equal elastic_product['invisible_in_search'], true

  end





  def test_with_oe_ref
    product = @product.find_by_sku  47124
    refute_nil product
    elastic_product = @product_transformer.run product
    refute_nil elastic_product
    assert_equal elastic_product['visible_in_catalog'], false
    assert_equal elastic_product['invisible_in_search'], true

  end

  def test_ti_not_external_oe_ref
    product = @product.find_by_sku  48228
    elastic_product = @product_transformer.run product
    refute_nil elastic_product
  end

end

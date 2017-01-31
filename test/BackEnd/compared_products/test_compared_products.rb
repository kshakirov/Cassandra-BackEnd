require_relative '../test_helper'

class TestComparedProducts < Minitest::Test
  def setup
    @compared_product_model = TurboCassandra::ComparedProductsBackEnd.new
  end
  def test_insert
    result  = @compared_product_model.update({product: 1, customer_id: 1})
    result  = @compared_product_model.update({product: 2, customer_id: 1})
    assert result
  end
  def test_find
    products = @compared_product_model.find_by_customer(1, "W")
    products = JSON.parse products
    assert_equal(products.size, 2)
  end

  def test_delete
    result  = @compared_product_model.delete(1,1)
    assert result
  end

  def test_get_critical
    result  = @compared_product_model.update({product: 66750, customer_id: 1})
    result  = @compared_product_model.update({product: 64690, customer_id: 1})
    products = @compared_product_model.find_by_customer(1, "W")
    products = JSON.parse products
    assert_equal(products.size, 2)
  end

end
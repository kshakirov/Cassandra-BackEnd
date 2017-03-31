require_relative '../test_helper'

class TestComparedProducts < Minitest::Test
  def setup
    @compared_product_controller = TurboCassandra::Controller::ComparedProducts.new
  end
  def test_insert
    result  = @compared_product_controller.update({product: 1, customer_id: 1})
    result  = @compared_product_controller.update({product: 2, customer_id: 1})
    assert result
  end
  def test_find
    products = @compared_product_controller.find_by_customer(1, "W")
    assert_equal(products.size, 2)
  end

  def test_delete
    result  = @compared_product_controller.delete(1,1)
    assert result
  end

  def test_delete_all
    result  = @compared_product_controller.delete_all([{'id' => 1}])
    assert result
  end

  def test_count
    result  = @compared_product_controller.count_products([{'id' => 1}])
    assert_equal 3, result[:count]
  end

  def test_get_critical
    result  = @compared_product_controller.update({product: 66750, customer_id: 1})
    result  = @compared_product_controller.update({product: 64690, customer_id: 1})
    products = @compared_product_controller.find_by_customer(1, "W")
    assert_equal(products.size, 2)
  end

end
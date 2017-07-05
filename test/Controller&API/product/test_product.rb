require_relative "../test_helper"

class TestProduct < Minitest::Test

  def setup
    @product_api = TurboCassandra::API::Product.new
    @product_controller = TurboCassandra::Controller::Product.new
  end

  def test_find_product
    product = @product_api.find 1
    refute_nil product
    assert_equal 1, product.sku
  end

  def test_where_skus
    products = @product_api.where_skus [1, 64958]
    refute_nil products
    assert_equal 2, products.size
  end

  def test_controller_get_product
    product = @product_controller.get_product 47755
    refute_nil product
  end

  def test_controller_get_products
    products = @product_controller.get_products [1, 64958]
    refute_nil products
    assert_equal 2, products.size
  end

  def test_controller_paginated
    body = {'paging_state' => nil}
    products = @product_controller.paginate_products  body.to_json
    refute_nil products
    assert_equal 10, products[:results].size
  end

  def test_admin_product_price
    body = {'customer_group_id' => '2', 'id' => 64690 }
    product = @product_controller.get_admin_prouct_with_price body
    refute_nil product
    refute_nil product[:price]
  end

  def test_admin_product_non_ti
    body = {'customer_group_id' => '2', 'id' => 840 }
    product = @product_controller.get_admin_prouct_with_price body
    refute_nil product
  end

  def test_product_delete
    @product_api.delete 63064
    assert true
  end

  def test_application
  product = @product_controller.get_product 62958
  assert_equal 63, product['application_detail'].size
  end

end


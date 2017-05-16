require_relative "../test_helper"
class TestNewProduct < Minitest::Test

  def setup
    @new_product_controller =TurboCassandra::Controller::NewProduct.new
    @new_product_api =TurboCassandra::API::NewProduct.new
  end
  def test_get_featured_products
    list  = @new_product_controller.get_admin_list
    refute_nil list
  end

  def test_update_featured_product
    product = {
        sku: 62923,
        ord: 2,
        visible: false
    }
    list  = @new_product_controller.update_featured_product product.to_json
    refute_nil list
  end

  def test_add_product
    params = {'id' => '63005'}
    result = @new_product_controller.add_product params
    assert_equal  true, result[:result]
  end

  def test_menu_product

    result = @new_product_api.get_new_products
    assert_equal  true, result[:result]
  end

end
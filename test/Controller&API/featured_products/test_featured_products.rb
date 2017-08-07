require_relative "../test_helper"
class TestFeaturedProduct < Minitest::Test

  def setup
    @featured_product_controller =TurboCassandra::Controller::FeaturedProduct.new
    @featured_product_api =TurboCassandra::API::FeaturedProduct.new
  end

  def test_all_ctrl
    all  = @featured_product_api.all
    refute_nil all
  end

  def test_get_featured_products
    list  = @featured_product_controller.get_admin_list
    refute_nil list
  end

  def test_update_fp_order
    product = {
        sku: 64142,
        ord: 1,
        visible: true,
        part_number: '8-C-6331'
    }
    @featured_product_controller.update_featured_product product.to_json
  end

  def test_update_fp_visible
    product = {
        sku: 64142,
        ord: 1,
        visible: false,
        part_number: '8-C-6331'
    }
    @featured_product_controller.update_featured_product product.to_json
  end

  def test_update_fp_next
    product = {
        sku: 64142,
        ord: 100,
        visible: false,
        part_number: '8-C-6331'
    }
    @featured_product_controller.update_featured_product product.to_json
  end

  def test_delete
    params  = {
        "id" => '64142'
    }
    @featured_product_controller.delete_product params
  end

  def test_add
    params = {
        'id' => 64142,
    }
    @featured_product_controller.add_product params
  end

  def test_add_part_number
    params = {
        'id' => '5-A-0333',
    }
    @featured_product_controller.add_product params
  end

 

end
require_relative "../test_helper"
class TestCart < Minitest::Test

  def setup
    @cart_controller = TurboCassandra::Controller::Cart.new
    @cart_api = TurboCassandra::API::Cart.new
    @product_controller = TurboCassandra::Controller::Product.new
  end

  def test_find
    customer_data = [{'id' => 12}]
    cart = @cart_controller.get_customer_cart customer_data
    refute_nil cart
    assert_equal cart['id'], 12
  end

  def test_add_item
    customer_data = [{'id' => 487}]
    product = @product_controller.get_product 6232
    request_payload = {
        'product' => product,
        'price' => 74.8,
        'qty' => 2
    }

    @cart_controller.add_product_to_cart customer_data, request_payload.to_json
    response = @cart_controller.get_products_count(customer_data)
    assert_equal 2, response[:count].to_i
  end

  def test_delete_item
    customer_data = [{'id' => 487}]
    @cart_controller.delete_product_from_cart customer_data , 6232
  end

  def test_empty_cart
    customer_data = [{'id' => 487}]
    result = @cart_controller.empty_customer_cart customer_data
    assert result
  end

  def test_set_currency
    customer_data = [{'id' => 487}]
    body = {currency: "GBP" }
    result = @cart_controller.set_currency customer_data, body.to_json
    assert result
  end

  def test_update
    customer_data = [{'id' => 487}]
    cart = @cart_controller.get_customer_cart customer_data
    refute_nil cart
    body = {'cart' => cart}
    count   = @cart_controller.update_cart body.to_json
    assert_equal 2, count.to_i
  end

  def test_scale
    config  =TurboCassandra::System::Config.instance
    p config
  end

end
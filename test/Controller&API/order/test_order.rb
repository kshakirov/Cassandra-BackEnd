require_relative "../test_helper"
class TestOrder < Minitest::Test

  def setup
    @order_controler = TurboCassandra::Controller::Order.new
    @order_api = TurboCassandra::API::Order.new
    @order_json = '{"customer_id":null,"order_id":null,"billing_address":{"city":"Kiey","company":"Zoral","country_id":"US","lastname":"Kirill Jr Shakirov","name":"Kirill   Shakirov B.","postcode":"100021","region_id":"CO","street":"lipskaya 19/7,apt.4","telephone":"0979801197"},"shipping_address":{"city":"Kiey","company":"Zoral","country_id":"UA","lastname":"Kirill Jr Shakirov","name":"Kirill  Shakirov S.","postcode":"100021","street":"popudrenko 18, apt.3","telephone":"0979801197"},"currency_code":"USD","products":[{"sku":"43750","name":"3-A-0760","part_type":"Compressor Wheel","oem_part":"","quantity":"1","row_total":"23.106","subtotal":"23.106","original_price":"23.106","price":"23.106","item_status":"Ordered"}],"subtotal":"23.11","grand_total":"23.11"}'
  end

  def test_load_order
    order = @order_controler.get_order_by_customer_id 24
    refute_nil order
  end

  def test_create_order
    order = @order_controler.create_order 12
    assert order
    id  = @order_controler.save [{'id' => 12}], @order_json
    assert id
  end

  def test_next_id
    id  = @order_controler.save 12, {}
    assert id
  end



  def test_get_also_bought_product
    products  = @order_api.get_also_bought_products 43782
    refute_nil products
  end

  def test_admin_all
    orders  = @order_controler.all
    refute_nil orders
  end



end


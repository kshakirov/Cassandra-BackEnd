require_relative "../test_helper"
class TestOrder < Minitest::Test

  def setup
    @order_controler = TurboCassandra::Controller::Order.new
  end

  def test_load_order
    order = @order_controler.get_order_by_customer_id 12
    refute_nil order
  end

  def test_create_order
    order = @order_controler.create_order 12
    assert order



  end

  def test_next_id
    billing _address = {
    'city' => 'Alabama',
    'company' => 'Zoral',
    'country_id' => 'US',
    'postcode' => '123456',
    'region_id' => '1',
    'street' => 'not adress',
    'telephone' => '3434343434'
    }
    shipping _address = {
        'city' => 'Alabama',
        'company' => 'Zoral',
        'country_id' => 'US',
        'postcode' => '123456',
        'region_id' => '1',
        'street' => 'not adress',
        'telephone' => '3434343434'
    }
    data = {'base_currency_code' => "USD"}
    product = {'sku' => '6229',
    'name' => '1-A-0550',
    'part_type' => 'Cartridge'
    'oem_part' => nil
    'qty_ordered' => 1
    'qty_shipped' => 0
    'base_row_total' => 158.576
    'base_price_incl_tax' => 158.576}

    args  = [487, 100000335]
    id  = @order_controler.save 12, order
    assert id
  end
end


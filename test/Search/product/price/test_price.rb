require_relative '../test_helper'

class TestPrice < Minitest::Test
  def setup
    @price_manager = TurboCassandra::PriceManager.new
    @product_api = TurboCassandra::API::Product.new
  end
  def test_get_ti_part
    product = @product_api.find_by_sku 6229
    price  = @price_manager.get_price product
    refute_nil price
    assert_equal 10, price.keys.size
    assert_equal  178.398, price['0']
  end

  def test_get_non_ti_part
    product = @product_api.find_by_sku 2208
    price  = @price_manager.get_price product
    refute_nil price
    assert_equal 10, price.keys.size
    assert_equal  178.398, price['0']
  end

  def test_get_ti_part_err
    product = @product_api.find_by_sku 44984
    price  = @price_manager.get_price product
    refute_nil price
    assert_equal 10, price.keys.size
    assert_equal  5.346, price['0']
  end


  def test_get_cartridge_price
    price  = @price_manager.get_cartridge_price [{id: 1, sku: 6587}]
    refute_nil price
  end

end
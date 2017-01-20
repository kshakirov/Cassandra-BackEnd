require_relative '../test_helper'

class TestPrice < Minitest::Test
  def setup
    @price_manager = TurboCassandra::PriceManager.new
    @product_manager = TurboCassandra::Product.new
  end
  def test_get_ti_part
    product = @product_manager.find  42277
    price  = @price_manager.get_price product.first
    refute_nil price
  end

  def test_get_non_ti_part
    product = @product_manager.find  2208
    price  = @price_manager.get_price product.first
    refute_nil price
  end

  def test_get_ti_part_err
    product = @product_manager.find  44984
    price  = @price_manager.get_price product.first
    refute_nil price
  end


  def test_get_cartridge_price
    price  = @price_manager.get_cartridge_price [{id: 1, sku: 6587}]
    refute_nil price
  end

end
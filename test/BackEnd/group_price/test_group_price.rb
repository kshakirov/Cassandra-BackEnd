require_relative "test_helper"
class TestGroupPrice < Minitest::Test

  def setup
    @cart_model = TurboCassandra::GroupPriceBackEnd.new
  end

  def test_get_price
    price = @cart_model.get_price 48750, '4'
    p price
  end
end
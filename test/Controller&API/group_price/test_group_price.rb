require_relative "../test_helper"
class TestGroupPrice < Minitest::Test

  def setup
    @group_price_model = TurboCassandra::Controller::GroupPrice.new
  end

  def test_get_price
    price = @group_price_model.get_price 64690, '5'
    refute_nil price
  end
end
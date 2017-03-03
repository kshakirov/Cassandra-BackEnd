require_relative '../test_helper'


class TestShipment < Minitest::Test
  def setup
    @order_model = TurboCassandra::Model::Order.new
  end



  def test_find
    shipments =  @order_model.find_all_shipments
    refute_nil shipments
  end
end




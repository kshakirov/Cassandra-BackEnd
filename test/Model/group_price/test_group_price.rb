require '../test_helper'

class TestMessageLogModel < Minitest::Test
  def setup
    @group_price_model = TurboCassandra::Model::GroupPrice.new
  end

  def test_find
    sku = 64690
    customer_group_id = '5'
    result = @group_price_model.find_by_sku_group_id sku, customer_group_id
    assert result > 5
  end

end
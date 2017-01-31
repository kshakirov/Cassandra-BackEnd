require '../test_helper'

class TestComparedProducts < Minitest::Test
  def setup
      @compared_product_model = TurboCassandra::ComparedProducts.new
  end
  def test_insert
    result  = @compared_product_model.insert({product: 1, customer_id: 1, date:  Time.now.to_time})
    assert result
    result  = @compared_product_model.insert({product: 2, customer_id: 1, date:  Time.now.to_time})
    assert result
  end

  def test_find
    result  = @compared_product_model.find(1)
    assert_equal(result.size, 2)
  end

  def test_delete
    result  = @compared_product_model.delete(1,2)
    assert result
  end

end
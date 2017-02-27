require_relative 'test_helper'


class TestCustomer < Minitest::Test
  def setup
    @product_model = TurboCassandra::Model::Product.new
  end



  def test_find
    product =  @product_model.find [1]
    refute_nil product
  end
end




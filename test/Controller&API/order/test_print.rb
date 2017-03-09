require_relative 'test_helper'
class TestPrintOrder < Minitest::Test

  def test_render
    order = TurboCassandra::OrderBackEnd.new
    refute_nil order
    order.print(100000312)
  end
end
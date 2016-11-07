require_relative "../test_helper"
class TestInterchange < Minitest::Test
  def setup
    @product = TurboCassandra::Product.new
    @visibility_manager = TurboCassandra::PartType.new
  end

  def test_main
    p = @product.find  43747
    refute_nil p.first
    part = @visibility_manager.get_part_type p.first
    p part
  end
end
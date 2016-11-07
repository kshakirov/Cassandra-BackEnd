require_relative "../test_helper"
class TestInterchange < Minitest::Test
  def setup
    @product = TurboCassandra::Product.new
    @visibility_manager = TurboCassandra::CriticalDimension.new
  end

  def test_non_ti_interchange
    p = @product.find  43747
    refute_nil p.first
    criticals = @visibility_manager.get_critical_dimensions p.first
    p criticals
  end
end
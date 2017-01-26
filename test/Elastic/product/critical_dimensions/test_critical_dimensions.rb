require_relative "../test_helper"
class TestCriticalDims < Minitest::Test
  def setup
    @product = TurboCassandra::Product.new
    @visibility_manager = TurboCassandra::CriticalDimension.new
  end

  def test_all_critical
    p = @product.find  46073
    refute_nil p.first
    criticals = @visibility_manager.get_critical_dimensions p.first
    p criticals
  end

  def test_tolerance
    p = @product.find  45068
    refute_nil p.first
    criticals = @visibility_manager.get_critical_dimensions p.first
    p criticals
  end
end
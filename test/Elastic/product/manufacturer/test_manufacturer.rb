require_relative "../test_helper"
class TestInterchange < Minitest::Test
  def setup
    @product = TurboCassandra::Product.new
    @visibility_manager = TurboCassandra::Manufacturer.new
  end

  def test_non_ti_interchange
    p = @product.find  43747
    refute_nil p.first
    manfr = @visibility_manager.get_manufacturer p.first
    p manfr
  end
end
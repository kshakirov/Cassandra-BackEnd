require_relative "../test_helper"
class TestTiChra < Minitest::Test
  def setup
    @product = TurboCassandra::Product.new
    @chra_handler = TurboCassandra::TiChraManager.new
  end

  def test_ti_chra
    p = @product.find 68157
    refute_nil p.first
    ti_chra = @chra_handler.get_ti_chra p.first
    refute_nil ti_chra
  end

  def test_foreign_chra
    p = @product.find 19191
    refute_nil p.first
    ti_chra = @chra_handler.get_foreign_chra p.first
    refute_nil ti_chra
  end


end

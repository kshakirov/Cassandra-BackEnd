require_relative "../test_helper"
class TestApplication < Minitest::Test
  def setup
    @product = TurboCassandra::Product.new
    @application_manager = TurboCassandra::ApplicationManager.new
  end

  def test_main
    p = @product.find  43747
    refute_nil p.first
    app_hash = @application_manager.get_application p.first
    p app_hash
  end
end
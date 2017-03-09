require_relative 'test_helper'

class TestCritical < Minitest::Test
  def setup
    @menu_manager = TurboCassandra::MenuBackEnd.new
  end
  def test_featured
    featured = @menu_manager.get_featured_product
    refute_nil featured
  end

  def test_new
    new_products = @menu_manager.get_new_product
    refute_nil new_products
  end

end
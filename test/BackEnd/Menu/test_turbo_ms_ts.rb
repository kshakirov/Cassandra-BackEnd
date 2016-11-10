require_relative "test_helper"

class TestTurboTM < Minitest::Test
  def test_turbo_types
    menu_manager = TurboCassandra::MenuBackEnd.new
    filters = menu_manager.get_manufacturer_filters
    assert_equal 100,  filters['options']

  end
end

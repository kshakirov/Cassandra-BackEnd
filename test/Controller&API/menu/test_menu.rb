require_relative '../test_helper'

class TestMenu < Minitest::Test
  def setup

    @menu_controller = TurboCassandra::Controller::Menu::Main.new
  end

  def test_currency
    res = @menu_controller.get_currencies
    assert_equal 3, res.size
  end

  def test_manufacturers
    res = @menu_controller.get_manufacturers
    externals = res.first.find{|m| not TurboCassandra::Controller::NotExternalManufactures.is_external_manufacturer(m[1])}
    assert_equal nil, externals
  end




end
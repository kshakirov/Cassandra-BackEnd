require_relative '../test_helper'
class TestProdcutUpdate < Minitest::Test
  def setup
    @product_update_controller = TurboCassandra::Controller::ProductUpdate.new
    @system_data_api = TurboCassandra::API::SystemData.new
  end
  def test_main
    @product_update_controller.recurent_update
  end
  def test_get_system_data
    response = @system_data_api.find 'ip', name: 'elastic_instance'
    p response
  end
end
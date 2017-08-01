require_relative '../../test_helper'
class TestProductCreatedAt < Minitest::Test

  def setup
    @product_created_at_controller = TurboCassandra::Controller::ProductCreatedAt.new
  end

  def test_where
    body = {
        "manufacturer" => ['Turbo International'],
        "part_type" =>  ['Backplate', 'Compressor Wheel'],
        "page_size" => 10
    }
    response = @product_created_at_controller.where body.to_json
    refute_nil response
  end
end
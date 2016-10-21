require_relative "test_helper"
class TestCustomer < Minitest::Test

  def setup
    @customer_model = TurboCassandra::CustomerBackEnd.new
  end

  def test_load_customer
    cr = @customer_model.get_customer_info 487
    cr = JSON.parse cr
    p cr
  end
end
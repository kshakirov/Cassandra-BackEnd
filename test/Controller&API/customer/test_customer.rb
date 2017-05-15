require_relative "../test_helper"
class TestCustomer < Minitest::Test

  def setup
    @customer_controller = TurboCassandra::Controller::Customer.new
  end

  def test_load_customer_by_id
    customer_data = @customer_controller.get_account 12
    assert_equal customer_data['email'] , 'pthiry1@dbicapital.com', "Get Customer By Id Failed"
  end

  def test_get_customers_list
    customers_list = @customer_controller.get_all
    assert_equal customers_list.size, 4, "Customers List Failed"
  end

  def test_address
    data = {"id":487,"firstname":"Kirill","lastname":"Shakirov",
            "default_billing_address":{"city":"Auburn",
                                       "company":"Zoral","country_id":"US",
                                       "lastname":"Kirill Shakirov",
                                       "postcode":"123456","region_id":nil,
                                       "street":"19/7  Lipskaya",
                                       "telephone":"3434343434"}}

    response  = @customer_controller.update_address data.to_json

  end

end
require_relative 'test_helper'


class TestCustomer < Minitest::Test
  def setup
    @customer = TurboCassandra::Customer.new
  end

  def test_save
    hash = {'default_billing_address' =>  {'city' =>  "Alabama", 'company' =>  "Zoral",
                                      'country_id' =>  "US",
                                      'postcode' =>  "123456",
                                      'region' =>  nil,
                                      'region_id' =>  "1",
                                      'street' =>  "Lipskaya 19/7",
                                      'telephone' =>  "3434343434"},
            'firstname' =>  "Kirill", 'id' =>  487, 'lastname' =>  "Shakirov"
    }
    string, args  = @customer.prepare_key_values hash
    assert_equal "default_billing_address = ?,firstname = ?,lastname = ?", string
    assert_equal 4, args.size
    assert_equal  487, args[3]

    @customer.update(hash)
  end

  def test_create

  end
end
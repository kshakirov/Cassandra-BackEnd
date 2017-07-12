require_relative '../current_helper'

def prepare_address_to_update c, address_type
  data = {
      id: c['id'],
      firstname: c['firstname'],
      lastname: c['lastname'],
  }
  data[address_type] = c[address_type]
  data
end

def delete_lastname data, address_type
  unless data[address_type].nil?
    data[address_type].delete 'lastname'
  end
end


def process_customer c, address_type
  if c[address_type  ].class.name == 'Hash'
    if c[address_type].key? 'name'
      puts c[address_type]['name']
    else
      c[address_type]['name'] = "#{c['firstname']}  #{c['lastname']}"
      data = prepare_address_to_update(c, address_type)
      delete_lastname(data, address_type)
      begin
        @customer_controller.update_address data.to_json
      rescue
        puts "Error"
        p data
      end
    end
  end
end

@customer_controller = TurboCassandra::Controller::Customer.new
customers = @customer_controller.get_all
customers.each_with_index do |c, index|
  puts c['id']
  process_customer c, 'default_billing_address'
  process_customer c, 'default_shipping_address'
end
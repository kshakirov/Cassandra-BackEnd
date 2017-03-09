module TurboCassandra
  class CustomerBatch

    def initialize
      @price_group_map = {
          '11' => 'E',
          '12' => 'R',
          '13' => 'W',
          '14' => 'X',
          '5' => '0',
          '6' => '1',
          '7' => '2',
          '8' => '3',
          '9' => '4',
          '10' => '5'
      }
    end


    def gsub_group_id old_group_id
      @price_group_map[old_group_id]
    end

    def remove_null_values hash
      hash.select{|k,v| not v.nil? and not k=='0'}
    end

    def prepare_customer_hash customer_hash
      customer_hash = remove_null_values customer_hash
      dba, dsa = 'default_billing_address', 'default_shipping_address'
      customer_hash[dba] = remove_null_values(customer_hash[dba]) if customer_hash.key? dba
      customer_hash[dsa] = remove_null_values(customer_hash[dsa]) if customer_hash.key? dsa
      customer_hash['password'] = customer_hash['password'].first['value']
      customer_hash
    end
  end
end
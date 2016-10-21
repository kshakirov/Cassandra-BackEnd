module TurboCassandra
  class CustomerBackEnd
    def initialize
      @customer = Customer.new
    end

    def get_customer_info id
     @customer.find(id).to_json
    end
  end
end
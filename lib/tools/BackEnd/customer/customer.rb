module TurboCassandra
  class CustomerBackEnd
    public
    def initialize
      @customer = Customer.new
      @cart = Cart.new
      @login_manager = Login.new
    end

    def get_customer_info id
      @customer.find(id).to_json
    end

    def update data
      @customer.update data
    end

    def update_password data
      validated = @login_manager.validate_customer(data['password'], data['email'])
      if validated
          data['password'] = @login_manager.hash_password(data['password_new'])
          data.delete 'password_new'
          update(data)
      end
      validated
    end

    def get_customer_data customer
      {
          name: get_name(customer),
          cart: get_cart_items_number(customer),
          wishlist: 3
      }.to_json
    end

    def get_list
      customers = @customer.find_all
      customers.to_json
    end

    private

    def get_name customer
      customer['name']
    end

    def get_cart_items_number customer
      cart = @cart.find_by_customer_id(customer['id'])
      unless cart.nil?
        cart['items'].keys.size
      end
    end

    def create customer_data
        @customer.insert(customer_data)
    end
  end
end
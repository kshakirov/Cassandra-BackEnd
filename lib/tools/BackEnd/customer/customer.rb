module TurboCassandra
  class CustomerBackEnd
    public
    def initialize
      @customer = Customer.new
      @cart = Cart.new
    end

    def get_customer_info id
     @customer.find(id).to_json
    end

    def get_customer_data customer
        {
            name: get_name(customer),
            cart: get_cart_items_number(customer),
            wishlist: 3
        }.to_json
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
  end
end
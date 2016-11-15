module TurboCassandra
  class OrderBackEnd
    public
    def initialize
      @order = Order.new
      @customer = Customer.new
      @cart = Cart.new
    end

    private
    def _get_order id
      order = @order.find_by_customer_id(id)
      order.map { |o| o }
    end

    def get_customer_data customer_id
      customer_data = @customer.find customer_id
      {
          order_id: 1,
          customer_id: customer_id,
          data: {
              billing_address: customer_data['default_billing_address'],
              shipping_address: customer_data['default_shipping_address'],
              email: customer_data['email']

          }
      }
    end

    def get_products cart
      cart['items'].map { |key, value|
        {
            sku: key,
            name: value['ti_part'],
            part_type: value['part_type'],
            oem_part: value['oem_part'],
            qty_ordered: value['qty'].to_s,
            qty_shipped: 0.to_s,
            base_row_total: value['subtotal'].to_s,
            base_price_incl_tax: value['unit_price'].to_s,
        }
      }
    end


    def get_cart_data customer_id
      @cart.find_by_customer_id(customer_id)
    end

    def add_cart_info cart
      {
          base_subtotal: cart['subtotal'],
          base_currency_code: cart['currency']
      }
    end

    def _create_order customer_id
      data = get_customer_data(customer_id)
      cart = get_cart_data(customer_id)
      data['products'] = get_products(cart)
      data[:data].merge!(add_cart_info(cart))
      data
    end

    public

    def get_order_by_customer_id id
      _get_order(id).to_json
    end

    def create_order customer_id
      _create_order(customer_id).to_json
    end

    def save customer_id, order_data
        next_id = @order.get_next_order_id
        order_data['order_id'] = next_id + 1
        order_data['customer_id'] = customer_id
        @order.insert order_data
        #@cart.purge(customer_id)
        order_data
    end
  end
end
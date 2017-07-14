module TurboCassandra
  module Controller
    class Cart
      def initialize
        @customer = TurboCassandra::API::Customer.new
        @cart_api = TurboCassandra::API::Cart.new
      end

      private
      def get_customer_id env_customer
        env_customer.first['id']
      end

      def check_currency cart
        if cart['currency'].class.name == 'Hash'
          cart['currency']['code']
        else
            cart['currency']
        end
      end

      def verify_map_text map
        Hash[map.map{|m| [m[0].to_s, m[1].to_s]}]
      end

      def cart_items_to_int items
        Hash[items.map{|h| [h[0].to_i, verify_map_text(h[1])]}]
      end

      public
      def get_customer_cart customer_data
        customer_id = customer_data.first['id']
        @cart_api.find(customer_id)
      end

      def add_product_to_cart customer_data, request_payload
        customer_id = get_customer_id(customer_data)
        request_payload = JSON.parse(request_payload)
        @cart_api.add_product(customer_id, request_payload['product'],
                              request_payload['price'], request_payload['qty'])
      end

      def delete_product_from_cart customer_data, product_id
        customer_id = get_customer_id(customer_data)
        product_id = product_id.to_i
        @cart_api.delete_product(customer_id, product_id)
      end

      def empty_customer_cart customer_data
        customer_id = get_customer_id(customer_data)
        @cart_api.empty_cart(customer_id)
      end

      def get_products_count customer_data
        customer_id = get_customer_id(customer_data)
        {
           count:  @cart_api.count_products(customer_id)
        }
      end

      def update_cart body
        cart = JSON.parse(body)['cart']
        cart['items'] = cart_items_to_int(cart['items'])
        cart['currency'] = check_currency(cart)
        @cart_api.update cart
      end

      def set_currency customer_data, body
        body = JSON.parse body
        customer_id = get_customer_id(customer_data)
         @cart_api.set_currency customer_id, body['currency']
      end

    end
  end
end
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

    end
  end
end
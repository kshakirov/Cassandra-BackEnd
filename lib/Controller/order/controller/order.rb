module TurboCassandra
  module Controller
    class Order
      attr_accessor :order_api, :currency_api, :group_price_api, :product_api
      include Carmen
      include OrderPrint
      include AlsoBought
      include OrderAdminCreate
      include OrderProductCurrency

      def initialize
        @order_api = TurboCassandra::API::Order.new
        @customer_api = TurboCassandra::API::Customer.new
        @cart_api = TurboCassandra::API::Cart.new
        @currency_api = TurboCassandra::API::Currency.new
        @group_price_api = TurboCassandra::API::GroupPrice.new
        @product_api = TurboCassandra::API::Product.new
        config = TurboCassandra::System::Config.instance
        @scale = config.get_order_scale
        @total_keys = ['subtotal', 'discount_amount','row_total', 'tax_amount']
      end

      private

      def create_customer_order_data customer_id
        customer = @customer_api.find_by_customer_id customer_id
        {
            'customer_name' => customer.firstname + " " + customer.lastname,
            'customer_email' => customer.email
        }
      end

      def _get_order_by_customer_id id
        order = @order_api.find_by_customer_id(id)
        order.map {|o| o}
      end

      def get_customer_id env_customer
        env_customer.first['id']
      end

      def _get_order_by_id id
         @order_api.find_by_id(id)
      end

      def get_customer_data customer_id
        customer = @customer_api.find_by_customer_id customer_id
        {
            order_id: 1,
            customer_id: customer_id,
            data: {
                billing_address: customer.default_billing_address,
                shipping_address: customer.default_shipping_address,
                email: customer.email

            }
        }
      end


      def get_products cart
        products = cart['items'].map {|key, value|
          {
              sku: key,
              name: value['ti_part'],
              part_type: value['part_type'],
              oem_part: value['oem_part'] || '',
              quantity: value['qty'].to_s,
              row_total: value['subtotal'].to_s,
              subtotal: value['subtotal'].to_s,
              original_price: value['unit_price'].to_s,
              price: value['unit_price'].to_s,
              item_status: 'Ordered'
          }
        }
        products.sort{|a,b| a[:sku] <=> b[:sku] }
      end


      def get_cart_data customer_id
        @cart_api.find(customer_id)
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

      def get_address_name order, address_type
        unless order['address_type'].nil?
          if order[address_type].key? 'name'
            order[address_type]['name']
          elsif order[address_type].key? 'lastname'
            "#{order[address_type]['firstname']} #{order[address_type]['lastname']}"
          elsif order['data'].key? 'customer_name'
            order['data']['customer_name']
          end
        end
      end


      def _all
        orders = @order_api.all
        orders.map do |order|
          {
              order_id: order['order_id'],
              billing_name: get_address_name(order, 'billing_address'),
              shipping_name: get_address_name(order, 'shipping_address'),
              grand_total: order['grand_total'],
              subtotal: order['subtotal'],
              updated_at: order['updated_at']

          }
        end
      end

      public

      def get_order_by_customer_id id
        _get_order_by_customer_id(id)
      end

      def create_order customer_id
        _create_order(customer_id)
      end

      def save customer_data, body
        customer_id = get_customer_id(customer_data)
        order_data = JSON.parse body
        next_id = @order_api.get_next_order_id
        order_data['order_id'] = next_id + 1
        order_data['customer_id'] = customer_id
        order_data['data'] = create_customer_order_data(customer_id)
        order_data['updated_at'] = Time.now
        calculate_prices(order_data)
        @order_api.insert order_data
        @cart_api.empty_cart(customer_id)
        order_data
      end

      def get_order order_id
        _get_order_by_id (order_id)

      end

      def find order_id
        _get_order_by_id (order_id)
      end

      def find_all_by_customer customer_id
        get_order_by_customer_id(customer_id)
      end

      def all
        _all
      end

      def all_shipments
        @order_api.all_shipments
      end

      def find_shipment_by_order_id params
        order_id = params['order_id'].to_i
        id = params['id'].to_i
        @order_api.find_shipment_by_order_id(order_id, id)
      end

      def find_shipment_only_by_order_id params
        order_id = params['order_id'].to_i
        @order_api.find_shipment_only_by_order_id(order_id)
      end

      def print order_id
        order = _get_order_by_id (order_id)
        print_order(order)
      end

      def create_order_by_admin body
        order_data = JSON.parse body
        _create_order_by_admin order_data
      end

    end
  end
end
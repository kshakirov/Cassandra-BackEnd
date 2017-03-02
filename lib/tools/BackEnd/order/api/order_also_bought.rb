module TurboCassandra
  module API
    module AlsoBought
      private
      def map_product_orders order_data
        order_data['products'].map { |p| p['sku'] }
      end

      def map_order_products order_data
        order_data['products'].map { |p| {sku: p['sku'], name: p['name']} }
      end

      def make_product_data_2_register order_data, p
        {
            order_id: order_data['order_id'].to_i,
            sku: p.to_i
        }
      end

      def make_order_data_2_register order_data, p
        {
            order_id: order_data['order_id'].to_i,
            sku: p[:sku].to_i,
            name: p[:name] || ''
        }
      end

      public
      def register_order_product order_data
        products = map_order_products(order_data)
        products.each do |p|
          @order_model.insert_order_product(make_order_data_2_register(order_data, p))
        end
      end

      def register_product_order order_data
        products = map_product_orders(order_data)
        products.each do |p|
          @order_model.insert_product_order(make_product_data_2_register(order_data, p))
        end
      end

      def get_also_bought_products sku
          @order_model.find_orders_by_product sku
      end

    end
  end
end
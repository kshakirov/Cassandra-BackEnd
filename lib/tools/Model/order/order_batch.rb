module TurboCassandra
  module API
    class OrderBatch
      def process_order_data order_hash
        order_hash['data'].select { |k, v| not v.nil? }
      end

      def process_order_products order_hash
        order_hash['products'].map { |product|
          product[0].select { |k, v| not v.nil? }
        }
      end

      def remove_null_values order_hash
        order_hash['data'] = process_order_data(order_hash)
        order_hash['products'] = process_order_products(order_hash)
      end
    end
  end
end
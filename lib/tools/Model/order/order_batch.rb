module TurboCassandra
  module API
    class OrderBatch

      def coerce_products  products
        products.map{|hash|   Hash[hash.map { |k, v| [k, v.to_s] }]}
      end

      def coerce_data o
        o['order_id'] = o['order_id'].to_i
        o['customer_id'] = o['customer_id'].to_i
        o['customer_id'] = o['customer_id'].to_i
        o['grand_total_invoiced'] = o['ground_total_invoiced'].to_f
        o.delete 'ground_total_invoiced'
        o['subtotal'] = o['subtotal'].to_f
        o['shipping_handling'] = o['shipping_handling'].to_f
        o['grand_total'] = o['grand_total'].to_f
        o['updated_at']  =  Time.parse o['updated_at']
        o['products']  =  coerce_products(o['products'])
      end
    end
  end
end
module TurboCassandra
  module API
    module ShipmentBatch
      def remove_null_values hashes
        if hashes.class.name == 'Hash'
          hashes.compact!
          Hash[hashes.map { |k, v| [k, remove_null_values(v)] }.flatten]
        elsif hashes.class.name == "Array"
          hashes.map{|hash| remove_null_values(hash)}
        end
        hashes
      end
      def coerce_to_integer h
        h['order_id'] = h['order_id'].to_i
        h['id'] = h['id'].to_i
        h['order_id'] = h['order_id'].to_i
        h['customer_id'] = h['customer_id'].to_i
        h['total_qty'] = h['customer_id'].to_i
        h['total_weight'] = h['customer_id'].to_i
        h['created_at']  =  Time.parse h['created_at']
        h['updated_at']  =  Time.parse h['updated_at']
      end
    end
  end
end

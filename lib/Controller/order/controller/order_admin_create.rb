module TurboCassandra
  module Controller
    module OrderAdminCreate

      def stringify hash
        Hash[hash.map { |k, v| [k.to_s, v.to_s] }]
      end

      def coerce_price price, scale
        BigDecimal.new(price.to_s).
            round(scale,BigDecimal::EXCEPTION_NaN)
      end

      def is_total_key?  key
        @total_keys.include? key
      end

      def stringify_products products
        products.each do |product|
          product.each do |key, value|
            if is_total_key? key
            product[key] = coerce_price(value, @scale['total']).to_s
            elsif key=='price'
              product[key] = coerce_price(value, @scale['item']).to_s
            else
              product[key] =value.to_s
            end
          end
        end
      end

      def validate_order order_data
        order_data['products'] = stringify_products(order_data['products'])
        order_data['billing_address'] = stringify(order_data['billing_address'])
        order_data['shipping_address'] = stringify(order_data['shipping_address'])
        order_data['shipping_handling'] =coerce_price(order_data['shipping_handling'],@scale['total'])
        order_data['subtotal'] =coerce_price(order_data['subtotal'], @scale['subtotal'])
        order_data['grand_total'] = coerce_price(order_data['grand_total'], @scale['total'])
        order_data['updated_at'] = Time.now.to_time
        order_data
      end
      def _create_order_by_admin order_data
        last_id = @order_api.get_next_order_id
        order_data['order_id'] = last_id + 1
        @order_api.insert(validate_order(order_data))
        {
            order_id: last_id + 1
        }
      end
    end
  end
end
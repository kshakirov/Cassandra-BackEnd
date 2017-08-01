module TurboCassandra
  module Controller
    module OrderProductCurrency

      def get_rate currencies, current_currency
        currency = currencies.select { |c| c['code'] == current_currency }
        currency.first['rate']
      end


      def render_price price, rate, scale
        price = BigDecimal.new(price) .round(scale, BigDecimal::EXCEPTION_NaN) * rate
        "#{price.round(scale)}"
      end

      def calculate_products products, rate
        products.map do |product|
          product['row_total'] =  render_price(product['row_total'], rate, @scale['total'])
          product['subtotal'] = render_price(product['subtotal'],rate, @scale['subtotal'])
          product['price'] = render_price(product['price'], rate, @scale['item'])
          product['original_price'] = render_price(product['original_price'],rate, @scale['item'])
          product
        end
      end

      def calculate_order order, rate
        order['subtotal'] = (BigDecimal.new(order['subtotal'].to_s) * rate).round(@scale['subtotal'])
        order['grand_total'] = (BigDecimal.new(order['grand_total'].to_s) * rate).round(@scale['total'])
      end

      def calculate_prices order
        rate =  get_rate @currency_api.all, order['currency_code']
        order['products'] = calculate_products(order['products'], rate)
        calculate_order order, rate
      end
    end
  end
end
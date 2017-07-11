module TurboCassandra
  module Controller
    module OrderProductCurrency

      def get_rate currencies, current_currency
        currency = currencies.select { |c| c['code'] == current_currency }
        currency.first['rate']
      end


      def render_price price, rate
        price = price.to_f * rate
        "#{price.round(2)}"
      end

      def calculate_products products, rate
        products.map do |product|
          product['row_total'] =  render_price(product['row_total'], rate)
          product['subtotal'] = render_price(product['subtotal'],rate)
          product['price'] = render_price(product['price'], rate)
          product['original_price'] = render_price(product['original_price'],rate)
          product
        end
      end

      def calculate_order order, rate
        order['subtotal'] = (BigDecimal.new(order['subtotal']) * rate).round(2)
        order['grand_total'] = (BigDecimal(order['grand_total']) * rate).round(2)
      end

      def calculate_prices order
        rate =  get_rate @currency_api.all, order['currency_code']
        order['products'] = calculate_products(order['products'], rate)
        calculate_order order, rate
      end
    end
  end
end
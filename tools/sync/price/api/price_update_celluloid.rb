module TurboCassandra
  module Sync
    module Price
      class PriceUpdater
        def initialize
          @price_rest = TurboCassandra::Sync::Price::Rest.new
          @group_price_api = TurboCassandra::API::GroupPrice.new
          @product_api = TurboCassandra::API::Product.new
          config = TurboCassandra::System::Config.instance
          @scale = config.get_group_price
          @batch_size = 100
        end

        private
        def round_price price
          unless price.nil?
            BigDecimal.new(price.to_s).round(@scale['item'], BigDecimal::EXCEPTION_NaN)
          end
        end

        def prep_group_prices prices
          unless prices.nil?
            Hash[prices.map {|k, v| [k, round_price(v)]}]
          end
        end

        def update_product_prices prices
          prices.each do |price|
            hash = {
                sku: price['partId'],
                prices: prep_group_prices(price['prices']),
                standardprice: round_price(price['standardPrice'])
            }
            @group_price_api.create hash
          end
        end

        def get_all_ti_products
          response = @product_api.paginate nil, @batch_size
          products = response[:results].select {|p| p['manufacturer'] == "Turbo International"}
          until response[:last] do
            response = @product_api.paginate response[:paging_state], @batch_size
            products = products + response[:results].select {|p| p['manufacturer'] == "Turbo International"}
          end
          products
        end

        public
        def run
          products = get_all_ti_products
          counter = 0
          products.each_slice(@batch_size) do |ps_slice|
            prices = @price_rest.run ps_slice
            update_product_prices prices
            counter += ps_slice.size
            puts "Updated #{counter}  from #{products.size} products"
          end
        end
      end
    end
  end
end
module TurboCassandra
  module Sync
    module Price
      class PriceUpdater
        def initialize
         # @product_model =TurboCassandra::Model::ProductCreatedAt.new
          @price_rest = TurboCassandra::Sync::Price::Rest.new
          @group_price_api = TurboCassandra::API::GroupPrice.new
          config = TurboCassandra::System::Config.instance
          @scale = config.get_group_price
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

        def process_response paging_state
          paging_params = {
              'paging_state' => paging_state,
              'page_size' => 100
          }
          response = TurboCassandra::Model::ProductCreatedAt.paginate  paging_params, manufacturer:"Turbo International"
          update_product_prices(@price_rest.run response[:results])
          return response[:last], response[:paging_state]
        end

        public
        def run
          counter = 0
          paging_state = nil
          last_batch = false

          until last_batch do
            last_batch, paging_state = process_response paging_state
            counter+=1
            puts "Processed   [#{counter * 100}] Products"
          end
        end
      end
    end
  end
end

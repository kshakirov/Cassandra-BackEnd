module TurboCassandra
  module Sync
    module Price
      class Rest
        def initialize
          @url = 'timms.turbointernational.com:8080/magmi/prices?inputtype=id'
          @group_price_api = TurboCassandra::API::GroupPrice.new
          config = TurboCassandra::System::Config.instance
          @scale = config.get_group_price
        end

        private

        def get_prices_from_timms ids
          response = RestClient.post @url, ids.to_json, :content_type => :json, :accept => :json
          unless response.nil?
            JSON.parse response
          end
        end

        public
        def run product_hashes
          ids = product_hashes.map {|hash| hash['sku']}
          get_prices_from_timms ids
        end
      end
    end
  end
end
module TurboCassandra
  module Controller
    class GroupPrice
      extend Forwardable

      def initialize
        @group_price_api = TurboCassandra::API::GroupPrice.new
      end

      def get_prices params
        @group_price_api.find(params['id'].to_i)
      end

      def set_prices body
        hash = JSON.parse body
        @group_price_api.create hash
      end

      def_delegator :@group_price_api, :find_by_sku_group_id, :get_price
    end
  end
end
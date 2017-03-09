module TurboCassandra
  module Controller
    class GroupPrice
      extend Forwardable

      def initialize
        @group_price_api = TurboCassandra::API::GroupPrice.new
      end

      def_delegator :@group_price_api, :find_by_sku_group_id, :get_price
    end
  end
end
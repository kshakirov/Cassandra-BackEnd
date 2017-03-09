module TurboCassandra
  module API
    class GroupPrice
      extend Forwardable

      def initialize
        @group_price_model = TurboCassandra::Model::GroupPrice.new
      end

      def_delegator :@group_price_model, :find_by_sku_group_id, :find_by_sku_group_id
      def_delegator :@group_price_model, :find, :find
      def_delegator :@group_price_model, :insert, :create
    end
  end
end
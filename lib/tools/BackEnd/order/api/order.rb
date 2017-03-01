module TurboCassandra
  module API
    class Order
      extend Forwardable
      def initialize
        @order_model = TurboCassandra::Model::Order.new
      end
      def_delegator :@order_model, :find_by_customer_id, :find_by_customer_id
      def_delegator :@order_model, :find_by_id, :find_by_id
      def_delegator :@order_model, :get_next_order_id, :get_next_order_id
      def_delegator :@order_model, :insert, :insert
      def all
          @order_model.find_all
      end
    end

  end
end
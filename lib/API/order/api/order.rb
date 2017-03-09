module TurboCassandra
  module API
    class Order
      attr_accessor :order_model
      extend Forwardable
      include AlsoBought
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
      def all_shipments values = []
        shipments = @order_model.find_all_shipments
        unless values.empty?
          shipments.map{|s|

          }
        end
        shipments
      end
      def find_shipment_by_order_id order_id, id
          @order_model.find_shipment_by_order_id(order_id, id)
      end

      def find_shipment_only_by_order_id order_id
        @order_model.find_shipment_only_by_order_id(order_id)
      end
    end
  end
end
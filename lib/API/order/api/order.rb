module TurboCassandra
  module API
    class Order
      attr_accessor :order_model, :product_api
      extend Forwardable
      include ProductInterchangeResolver
      include AlsoBought
      def initialize
        @product_api = TurboCassandra::API::Product.new
        @invoice_api = TurboCassandra::API::Invoice.new
      end


      def find_by_customer_id customer_id
        TurboCassandra::Model::Order.find_by customer_id: customer_id
      end

      def find_by_id order_id
        order = TurboCassandra::Model::Order.find order_id
        unless order.nil?
          order.to_hash
        end
      end

      def get_next_order_id
        TurboCassandra::Model::Order.max
      end

      def insert order_hash
        order = TurboCassandra::Model::Order.new order_hash
        order.save
      end

      def all
        TurboCassandra::Model::Order.all
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

      def  get_also_bought_products sku
        @invoice_api.get_also_bought_prods sku
      end
    end
  end
end
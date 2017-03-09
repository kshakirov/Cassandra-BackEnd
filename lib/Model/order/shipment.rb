module TurboCassandra
  module Model
    module Shipment
      def insert_shipment hash
        names, values, args = prepare_attributes! hash
        execute_query(shipment_insert_cql(names, values), args)
      end

      def find_all_shipments
        shipments = execute_query_inconsistent(shipment_select_all_cql,[])
        unless shipments.nil?
          shipments.map { |shipment| shipment }
        end
      end
      def find_shipment_by_order_id order_id, id
        shipment = execute_query_inconsistent(shipment_select_where_cql,
                                              [order_id, id])
        unless shipment.nil?
          shipment.first
        end
      end

      def find_shipment_only_by_order_id order_id
        shipments = execute_query_inconsistent(shipment_select_where_id_cql,
                                              [order_id])
        unless shipments.nil?
          shipments.map{|shipment| shipment}
        end
      end

    end
  end
end
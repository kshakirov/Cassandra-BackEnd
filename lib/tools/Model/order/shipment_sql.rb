module TurboCassandra
  module Model
    module Shipment
      def shipment_insert_cql names, values
        "INSERT INTO shipments  (#{names})  VALUES (#{values})"
      end
      def shipment_select_all_cql names="*"
        "SELECT #{names} FROM shipments"
      end
    end
  end
end
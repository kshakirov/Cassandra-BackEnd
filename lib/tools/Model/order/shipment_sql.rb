module TurboCassandra
  module Model
    module Shipment
      def shipment_insert_cql names, values
        "INSERT INTO shipments  (#{names})  VALUES (#{values})"
      end

    end
  end
end
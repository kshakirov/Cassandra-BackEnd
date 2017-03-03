module TurboCassandra
  module Model
    module Shipment
     def insert_shipment hash
       names, values, args = prepare_attributes! hash
       execute_query(shipment_insert_cql(names, values), args)
     end
    end
  end
end
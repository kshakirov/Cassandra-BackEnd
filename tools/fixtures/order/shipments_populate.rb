require_relative '../tools_helper'

 order = TurboCassandra::Model::Order.new
 order_batch = TurboCassandra::API::OrderBatch.new
shipments = read_shipments_from_file
include TurboCassandra::API::ShipmentBatch
shipments.each do |o|
 oo=  remove_null_values o
 coerce_to_integer(oo)
  p oo
  order.insert_shipment(oo)
end
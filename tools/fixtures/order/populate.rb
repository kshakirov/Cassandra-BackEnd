require_relative '../tools_helper'

order = TurboCassandra::API::Order.new
order_batch = TurboCassandra::API::OrderBatch.new
orders = read_orders_from_file
include TurboCassandra::API::ShipmentBatch
orders.each do |o|
  order_batch.coerce_data(o)
  puts o['order_id']
  oo =remove_null_values o
  order.insert oo
  order.register_also_bought_products(oo)

end
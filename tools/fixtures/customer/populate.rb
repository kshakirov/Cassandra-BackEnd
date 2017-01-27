require_relative '../tools_helper'

customers_hashes = read_customers_from_file
customer = TurboCassandra::Customer.new
customer_batch = TurboCassandra::CustomerBatch.new

customers_hashes.each_with_index do |customer_hash|
  customer_hash['id'] = customer_hash['id'].to_i
  customer_hash =  customer_batch.prepare_customer_hash(customer_hash)
  customer_hash['group_id'] = customer_batch.gsub_group_id(customer_hash['group_id'])
  customer.insert customer_hash
end

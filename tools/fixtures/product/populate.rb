require_relative '../tools_helper'
require_relative 'tcas_client'

tcas_client = TcasClient.new get_tcas_host
product = TurboCassandra::Model::Product.new
product_batch = TurboCassandra::API::Batch::Product.new
product_hashes = read_product_from_file

product_hashes.each_with_index do |product_hash, index|
  sku = product_hash['sku']
  product_batch.remove_keys(product_hash)
  product_batch.prepare_interchanges(product_hash, tcas_client.query_interchanges(sku))
  product_batch.prepare_ti_part(product_hash, tcas_client.query_interchanges(sku))
  product_batch.parse_critical_attributes(product_hash)
  product.insert product_hash
  puts "PRODUCT SKU[#{sku.to_s}] UPDATED"
end



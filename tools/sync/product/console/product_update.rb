require_relative '../../sync_helper'
elastic_host = get_elastic_host
metadata_server = get_metdata_host
product_api = TurboCassandra::API::Product.new
index_manager = TurboCassandra::ElasticIndex.new(elastic_host)
updater = TurboCassandra::Sync::Product::Rest.new(metadata_server)
product_hashes = updater.update
product_hashes.map do |p|
  if p[:action] == 'update'
    product = product_api.find_by_sku p[:sku]
    unless product.nil?
      index_manager.add_product product
      puts "PRODUCT [#{p[:sku]} UPDATED IN ELASTIC"
    end
  elsif p[:action] == 'delete'
    begin
      index_manager.delete_product p[:sku]
      puts "PRODUCT [#{p[:sku]}  DELETED FROM ELASTIC"
    rescue Exception => e
      puts "PRODUCT [#{p[:sku]} ALREADY DELETED FROM ELASTIC"
    end
  end
end
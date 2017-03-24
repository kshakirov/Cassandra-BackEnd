require_relative 'sync_helper'
elastic_host = get_elastic_host
tcas_host = get_tcas_host
product_api = TurboCassandra::API::Product.new
index_manager = TurboCassandra::ElasticIndex.new(elastic_host, tcas_host)
updater = TurboCassandra::Sync::Product::Rest.new(TcasClient.new(get_tcas_host))
product_hashes = updater.update
product_hashes.map do |p|
  product  = product_api.find_by_sku  p[:sku]
  index_manager.add_product product
end
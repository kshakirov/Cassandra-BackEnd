require_relative 'indexer_helper'


elastic_host = get_elastic_host
tcas_host = get_tcas_host
product = TurboCassandra::API::Product.new
index_manager = TurboCassandra::ElasticIndex.new(elastic_host, tcas_host)

product.each { |r|
  p r['sku']
  index_manager.add_product r
}
require_relative 'inxexer_helper'


elastic_host = get_elastic_host
product = TurboCassandra::API::Product.new
index_manager = TurboCassandra::ElasticIndex.new(elastic_host)

product.each { |r|
  p r['sku']
  index_manager.add_product r
}
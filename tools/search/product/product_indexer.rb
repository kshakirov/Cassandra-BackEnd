require_relative 'indexer_helper'


elastic_host = get_elastic_host
tcas_host = get_tcas_host
product = TurboCassandra::API::Product.new
index_manager = TurboCassandra::ElasticIndex.new(elastic_host, tcas_host)

counter=1
start_time = Time.now
product.each { |p|
  index_manager.add_product p
  elapsed_seconds = ((Time.now - start_time)).to_i
  puts " #{counter} : #{p['sku']}  Time Elapsed [#{elapsed_seconds.to_s}]"
  counter+=1
}
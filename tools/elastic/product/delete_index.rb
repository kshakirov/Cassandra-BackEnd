require_relative 'indexer_helper'
elastic_host = get_elastic_host
name = "magento_product"
index_manager = TurboCassandra::ElasticIndex.new(elastic_host)
index_manager.delete name
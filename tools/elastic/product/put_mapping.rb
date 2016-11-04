require_relative 'inxexer_helper'

index_manager = TurboCassandra::ElasticIndex.new

attributes = read_attributes_from_file
 index_manager.put_mapping  'magento_product', 'product'
 index_manager.put_critical_mapping  'magento_product', 'product', attributes
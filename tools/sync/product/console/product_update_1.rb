require_relative '../../sync_helper'
product_recurrent_update_api = TurboCassandra::API::ProductRecurrentUpdate.new
updater = TurboCassandra::Sync::Product::Updater.new get_elastic_host, get_index_name, get_metdata_host
products = updater.run

products.each do |p|
  product_recurrent_update_api.log p
end


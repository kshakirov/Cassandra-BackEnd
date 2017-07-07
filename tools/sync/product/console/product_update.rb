require_relative '../../sync_helper'
require_relative 'product_updater'

updater = TurboCassandra::Sync::Product::Updater.new get_elastic_host, get_index_name, get_metdata_host
updater.run

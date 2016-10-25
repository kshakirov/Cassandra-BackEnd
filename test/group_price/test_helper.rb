require 'yaml'
require 'logger'
require 'cassandra'
require 'active_support'
require 'active_support/all'
require_relative '../../lib/tools/Model/turbo_cluster'
require_relative '../../lib/tools/Model/group_price/group_price'
require_relative '../../lib/tools/Model/group_price/group_batch'


def read_group_prices_from_file
  YAML.load_file('../product/one_product.yml')
  #YAML.load_file('../all_products.yml')
end
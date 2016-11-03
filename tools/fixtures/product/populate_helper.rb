require 'yaml'
require 'logger'
require 'cassandra'
require 'active_support'
require 'active_support/all'
require_relative '../../../lib/tools/Model/product/product'
require_relative '../../../lib/tools/Model/product/product_batch'
require_relative '../../../lib/tools/Model/turbo_cluster'

def read_product_from_file
  YAML.load_file('../all_products.yml')
end
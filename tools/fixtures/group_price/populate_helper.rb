require 'yaml'
require 'json'
require 'logger'
require 'cassandra'
require 'active_support'
require 'active_support/all'
require_relative '../../../lib/tools/Model/turbo_cluster'
require_relative '../../../lib/tools/Model/group_price/group_price'
require_relative '../../../lib/tools/Model/group_price/group_batch'


def read_group_prices_from_file
  YAML.load_file(File.expand_path( '../data/all_products.yml', File.dirname(__FILE__)))
end
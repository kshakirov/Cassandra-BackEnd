require 'yaml'
require 'json'
require 'logger'
require 'cassandra'
require 'active_support'
require 'active_support/all'
require_relative '../../../lib/tools/Model/order/order'
require_relative '../../../lib/tools/Model/order/order_batch'
require_relative '../../../lib/tools/Model/turbo_cluster'

def read_orders_from_file
  fd = File.open(File.expand_path( '../data/orders.json', File.dirname(__FILE__)), 'r')
  data = fd.read
  JSON.parse data
end
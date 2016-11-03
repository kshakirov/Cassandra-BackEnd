require 'yaml'
require 'json'
require 'logger'
require 'cassandra'
require 'active_support'
require 'active_support/all'
require_relative '../../../lib/tools/Model/turbo_cluster'
require_relative '../../../lib/tools/Model/customer/customer'
require_relative '../../../lib/tools/Model/customer/customer_batch'

def read_customers_from_file
  fd = File.open(File.expand_path( '../data/customers_production.json', File.dirname(__FILE__)), 'r')
  data = fd.read
  JSON.parse data
end
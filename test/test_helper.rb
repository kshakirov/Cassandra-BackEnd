require 'yaml'
require 'logger'
require 'cassandra'
require 'active_support'
require 'active_support/all'
require_relative '../lib/tools/Model/turbo_cluster'
require_relative '../lib/tools/Model/product/product'
require_relative '../lib/tools/Model/customer/customer'
require_relative '../lib/tools/Model/order/order'
require_relative '../lib/tools/Model/order/order_batch'
require_relative '../lib/tools/Model/visitor_log/visitor_logs'
require_relative '../lib/tools/BackEnd/visitor_log/visitor_logs'
class MyCluster
  def initialize
    cluster =Cassandra.cluster(hosts: ['10.1.3.15', '10.1.3.16', '10.1.3.17'])
    keyspace = 'trash1'
    @session = cluster.connect(keyspace)
  end

  def execute cql, args
    insert = @session.prepare(cql)
    @session.execute(insert, arguments: args, consistency: :any)
  end
end

def read_product_from_file
  YAML.load_file('../all_products.yml')
end

def read_attributes_from_file
  fd = File.open(__dir__ + '/../attribute.json', 'r')
  data = fd.read
  JSON.parse data
end
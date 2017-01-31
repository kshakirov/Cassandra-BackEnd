require 'json'
require 'cassandra'
require 'active_support'
require 'active_support/all'
require 'yaml'
require 'logger'
require_relative '../../lib/tools/Model/turbo_cluster'
require_relative '../../lib/tools/Model/attribute'
require_relative '../../lib/tools/Model/turbo_cluster'
require_relative '../../lib/tools/Model/attribute_set'
require_relative '../../lib/tools/Model/customer/customer'
require_relative '../../lib/tools/Model/customer/customer_batch'
require_relative '../../lib/sources'
require_relative '../../lib/tools/Model/group_price/group_price'
require_relative '../../lib/tools/Model/group_price/group_batch'
require_relative '../../lib/tools/Model/order/order'
require_relative '../../lib/tools/Model/order/order_batch'
require_relative '../../lib/tools/Model/turbo_cluster'
require_relative '../../lib/tools/Model/product/product'
require_relative '../../lib/tools/Model/product/product_batch'
require_relative '../../lib/tools/Model/turbo_cluster'


def check_environment r_path
   if ENV['TURBO_MODE']=='test'
     puts "TEST MODE"
     return  "../../test/" + r_path
   end
   puts "PRODUCTION MODE"
  r_path
end


def read_product_from_file
  YAML.load_stream(open(File.expand_path(  check_environment( 'data/all_products.yml'), File.dirname(__FILE__))))
end

def read_orders_from_file
  fd = File.open(
      File.expand_path( check_environment('data/orders.json'), File.dirname(__FILE__)), 'r'
  )
  data = fd.read
  JSON.parse data
end

def read_customers_from_file
  fd = File.open(
      File.expand_path( check_environment('data/customers_production.json'), File.dirname(__FILE__)), 'r'
  )
  data = fd.read
  JSON.parse data
end

def read_attribute_sets_from_file
  fd  = File.open(
      File.expand_path( check_environment('data/attribute_sets_all.json'), File.dirname(__FILE__)), 'r'
  )
  data = fd.read
  JSON.parse data
end

def read_attributes_from_file
  fd = File.open(
      File.expand_path( check_environment('data/attribute.json'), File.dirname(__FILE__)), 'r'
  )
  data = fd.read
  JSON.parse data
end

def read_group_prices_from_file
  YAML.load_file(
      File.expand_path( check_environment('data/all_products.yml'), File.dirname(__FILE__))
  )
end
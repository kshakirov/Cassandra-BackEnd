require 'cassandra'
require 'active_support'
require 'active_support/all'
require 'elasticsearch'
require 'yaml'
require 'json'
require_relative '../../../lib/sources'
require_relative '../../../lib/tools/Elastic/product/index'
require_relative '../../../lib/tools/Elastic/product/mapping'
require_relative '../../../lib/tools/Elastic/product/product_transformer'
require_relative '../../../lib/tools/Elastic/product/ti_interchange'
require_relative '../../../lib/tools/Elastic/product/oe_ref_url'
require_relative '../../../lib/tools/Elastic/product/critical_dimensions'
require_relative '../../../lib/tools/Elastic/product/manufacturer'
require_relative '../../../lib/tools/Elastic/product/part_type'
require_relative '../../../lib/tools/Elastic/product/utils'

def read_attributes_from_file
  fd = File.open(File.expand_path('../../fixtures/data/attribute.json', File.dirname(__FILE__)), 'r')
  data = fd.read
  JSON.parse data
end

def get_elastic_host
  host = ENV['ELASTIC_INSTANCE']
  unless host.nil?
    return host
  end
  puts "SET ELASTIC_INSTANCE VARIABLE"
  exit 1
end
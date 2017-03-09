require 'cassandra'
require 'active_support'
require 'active_support/all'
require 'elasticsearch'
require 'yaml'
require 'rest-client'
require 'json'
require_relative '../../../lib/sources'
require_relative '../../../lib/tools/Search/product/utils'
require_relative '../../../lib/tools/Search/product/index'
require_relative '../../../lib/tools/Search/product/mapping'
require_relative '../../../lib/tools/Search/product/product_transformer'
require_relative '../../../lib/tools/Search/product/ti_interchange'
require_relative '../../../lib/tools/Search/product/oe_ref_url'
require_relative '../../../lib/tools/Search/product/critical_dimensions'
require_relative '../../../lib/tools/Search/product/manufacturer'
require_relative '../../../lib/tools/Search/product/part_type'
require_relative '../../../lib/tools/Search/product/visibility'
require_relative '../../../lib/tools/Search/product/price_manager'
require_relative '../../../lib/tools/Search/product/application'
require_relative '../../../lib/tools/Search/application/application_transformer'
require_relative '../../../lib/tools/Search/application/mapping'
require_relative '../../../lib/tools/Search/product/ti_chra_manager'

def read_attributes_from_file
  fd = File.open(File.expand_path('../../fixtures/data/attribute.json', File.dirname(__FILE__)), 'r')
  data = fd.read
  JSON.parse data
end

def get_elastic_host
  config = YAML.load_file(File.expand_path( '../../../config/config.yaml', File.dirname(__FILE__)))
  if not config.nil?
    config[ENV['TURBO_MODE']]['elastic_host']
  else
    puts "SET ELASTIC_INSTANCE VARIABLE"
    exit 1
  end
end

def get_tcas_host
  config = YAML.load_file(File.expand_path( '../../../config/config.yaml', File.dirname(__FILE__)))
  if not config.nil?
    config[ENV['TURBO_MODE']]['tcas_host']
  else
    puts "SET ELASTIC_INSTANCE VARIABLE"
    exit 1
  end
end
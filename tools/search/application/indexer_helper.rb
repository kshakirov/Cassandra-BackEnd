require 'cassandra'
require 'active_support'
require 'active_support/all'
require 'elasticsearch'
require 'yaml'
require 'json'
require_relative '../../../lib/sources'
require_relative '../../../lib/Search/product/utils'
require_relative '../../../lib/Search/application/mapping'
require_relative '../../../lib/Search/application/application_transformer'
require_relative '../../../lib/Search/product/index'
require_relative '../../../lib/Search/product/mapping'
require_relative '../../../lib/Search/product/product_transformer'
require_relative '../../../lib/Search/product/ti_interchange'
require_relative '../../../lib/Search/product/oe_ref_url'
require_relative '../../../lib/Search/product/critical_dimensions'
require_relative '../../../lib/Search/product/manufacturer'
require_relative '../../../lib/Search/product/part_type'
require_relative '../../../lib/Search/product/visibility'
require_relative '../../../lib/Search/product/price_manager'
require_relative '../../../lib/Search/product/application'
require_relative '../../../lib/Search/product/ti_chra_manager'


def get_elastic_host
  config = YAML.load_file(File.expand_path( '../../../config/config.yaml', File.dirname(__FILE__)))
  if not config.nil?
    config[ENV['TURBO_MODE']]['elastic_host']
  else
    puts "SET ELASTIC_INSTANCE VARIABLE"
    exit 1
  end
end
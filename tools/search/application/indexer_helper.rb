require 'cassandra'
require 'active_support'
require 'active_support/all'
require 'elasticsearch'
require 'yaml'
require 'json'
require_relative '../../../lib/sources'
require_relative '../../../lib/tools/Search/application/mapping'
require_relative '../../../lib/tools/Search/application/application_transformer'
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

require_relative '../../../lib/tools/Search/product/utils'


def get_elastic_host
  host = ENV['ELASTIC_INSTANCE']
  unless host.nil?
    return host
  end
  puts "SET ELASTIC_INSTANCE VARIABLE"
  exit 1
end
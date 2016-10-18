require 'cassandra'
require 'active_support'
require 'active_support/all'
require 'elasticsearch'
require_relative '../../../lib/sources'
require_relative '../../../lib/tools/Elastic/product/index'
require_relative '../../../lib/tools/Elastic/product/mapping'
require_relative '../../../lib/tools/Elastic/product/product_transformer'
require_relative '../../../lib/tools/Elastic/product/ti_interchange'
require 'minitest/autorun'
require 'minitest/pride'

def read_attributes_from_file
  fd = File.open(__dir__ + '/../../attribute.json', 'r')
  data = fd.read
  JSON.parse data
end
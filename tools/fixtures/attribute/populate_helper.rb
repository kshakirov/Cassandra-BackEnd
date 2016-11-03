require 'yaml'
require_relative '../../../lib/tools/Model/turbo_cluster'
require_relative '../../../lib/tools/Model/attribute'
require 'json'
require 'cassandra'

def read_attributes_from_file
  fd = File.open(File.expand_path( '../data/attribute.json', File.dirname(__FILE__)), 'r')
  data = fd.read
  JSON.parse data
end




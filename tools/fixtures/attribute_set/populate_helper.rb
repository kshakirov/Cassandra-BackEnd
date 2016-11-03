require 'json'
require 'yaml'
require 'cassandra'
require 'active_support'
require 'active_support/all'
require_relative '../../../lib/tools/Model/turbo_cluster'
require_relative '../../../lib/tools/Model/attribute_set'

def read_attribute_sets_from_file
  fd  = File.open(File.expand_path( '../data/attribute_sets_all.json', File.dirname(__FILE__)), 'r')
  data = fd.read
  JSON.parse data
end

def read_attributes_from_file
  fd = File.open(File.expand_path( '../data/attribute.json', File.dirname(__FILE__)), 'r')
  data = fd.read
  JSON.parse data
end

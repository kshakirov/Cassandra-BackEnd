require 'cassandra'
require 'active_support'
require 'active_support/all'
require 'elasticsearch'
require 'yaml'
require 'rest-client'
require 'json'
require_relative '../../../lib/sources'
require_relative '../../../lib/Search/search_src'

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
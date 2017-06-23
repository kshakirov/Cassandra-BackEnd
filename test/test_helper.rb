require 'minitest/autorun'
require 'minitest/pride'
require 'json'
require 'yaml'
require 'cassandra'
require "march_hare"
require 'active_support'
require 'active_support/all'
require 'active_support/core_ext/hash/compact'
require 'active_directory'
require 'jwt'
require 'erb'
require 'action_view'
require 'action_view/helpers'
require 'prawn'
require 'prawn/table'
require 'carmen'
require 'carmen/country'
require_relative '../lib/sources'
ENV['TURBO_MODE'] = "test"



def read_product_from_file
  YAML.load_file('../all_products.yml')
end

def read_attributes_from_file
  fd = File.open(__dir__ + '/../attribute.json', 'r')
  data = fd.read
  JSON.parse data
end

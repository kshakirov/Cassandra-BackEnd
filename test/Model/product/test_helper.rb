require 'minitest/autorun'
require 'yaml'
require 'logger'
require 'cassandra'
require 'active_support'
require 'active_support/all'
require_relative '../../../lib/tools/Model/product/product'
require_relative '../../../lib/tools/Model/turbo_cluster'
ENV['TURBO_MODE'] = "test"

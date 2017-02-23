require 'minitest/autorun'
require 'minitest/pride'
require 'json'
require 'yaml'
require 'cassandra'
require 'minitest/autorun'
require_relative '../../lib/tools/Model/featured_new_product/featured_new_product'
require_relative '../../lib/tools/Model/turbo_cluster'
require_relative '../../lib/tools/Model/message_log/message_log'
require_relative '../../lib/tools/Model/cart/cart'

ENV['TURBO_MODE'] = "development"
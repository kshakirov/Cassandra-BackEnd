require 'minitest/autorun'
require 'minitest/pride'
require 'json'
require 'yaml'
require 'cassandra'
require_relative '../../lib/sources'
ENV['TURBO_MODE'] = "test"
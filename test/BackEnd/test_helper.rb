require 'minitest/autorun'
require 'minitest/pride'
require 'json'
require 'yaml'
require 'cassandra'
require "march_hare"
require 'active_support/core_ext/hash/compact'
require_relative '../../lib/sources'
ENV['TURBO_MODE'] = "development"
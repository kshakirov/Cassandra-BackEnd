require 'minitest/autorun'
require 'minitest/pride'
require 'json'
require 'yaml'
require 'cassandra'
require 'active_support/all'
require 'json'
require_relative '../../lib/sources'
require_relative '../../lib/WebAPI/web_source'

ENV['TURBO_MODE'] = "test"
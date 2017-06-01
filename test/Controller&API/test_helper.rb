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
require 'arangorb'
require_relative '../../lib/sources'
ENV['TURBO_MODE'] = "development"
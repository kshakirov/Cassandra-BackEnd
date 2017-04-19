require 'rest-client'
require 'json'
require 'cassandra'
require 'digest'
require 'jwt'
require 'yaml'
require 'logger'
require "march_hare"
require 'action_mailer'
require 'active_support'
require 'active_support/all'
require 'securerandom'
require 'prawn'
require 'prawn/table'
require_relative '../../lib/sources'
require_relative 'product/api/product'
require_relative '../../tools/search/product/indexer_helper'
ENV['TURBO_MODE'] = "development"

@config = YAML.load_file(File.expand_path('../../config/config.yaml', File.dirname(__FILE__)))

def get_metdata_host
  @config[ENV['TURBO_MODE']]['metadata_server']
end
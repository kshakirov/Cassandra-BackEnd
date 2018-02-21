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
require 'action_view'
require 'carmen'
require 'celluloid'
require_relative '../../lib/sources'
require_relative 'product/api/product'
require_relative 'product/api/bulk/part_rest_client'
require_relative 'product/api/bulk/bulk_delete_inactive'
require_relative 'product/api/bulk/bulk_update'
require_relative 'invoice/api/invoice'
require_relative 'price/api/price_rest'
require_relative 'price/api/price_update_celluloid'
require_relative '../../tools/search/product/indexer_helper'


@config = YAML.load_file(File.expand_path('../../config/config.yml', File.dirname(__FILE__)))


def get_metdata_host
  @config[ENV['TURBO_MODE']]['metadata_server']
end

def get_index_name
  "turbointernational_#{ENV['TURBO_MODE'].downcase}"
end

def get_elastic_host
  if not @config.nil?
    @config[ENV['TURBO_MODE']]['elastic_host']
  else
    puts "SET ELASTIC_INSTANCE VARIABLE"
    exit 1
  end
end
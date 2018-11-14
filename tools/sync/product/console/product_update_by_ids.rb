require_relative 'product_update_all_header'
require_relative '../../sync_helper'

if ARGV[0].nil?
  puts "Enter Ids of products you want to update, through coma"
  exit
end

class ProductUpdateById
  def initialize metadata_server, metadata_server_port
    @part_rest_client = PartRestClient.new metadata_server, metadata_server_port
    @logger = ::Logger.new(STDOUT)
    @logger.level = ::Logger::INFO
    @logger.progname ="BulkUpdateActive"
    @product_api = TurboCassandra::API::Product.new
    @product_batch = TurboCassandra::API::Batch::Product.new
  end

  private
  def parse_args arg
    arg.split(',').map {|a| a.to_i}
  end

  def prepare_product_data part
    product = part
    @product_batch.remove_keys(product)
    @product_batch.prepare_interchanges(product)
    @product_batch.parse_critical_attributes(product)
    @product_batch.derive_name(product)
    product
  end

  def _update parts
    parts.each do |p|
      product = prepare_product_data p
      @product_api.create product
      @logger.info "Updated [#{product['sku']}]"
    end
  end

  public
  def update args
    ids = parse_args args
    parts = @part_rest_client.query_bulk ids
    _update parts
  end
end

metadata_server = get_metdata_host
metadata_port = get_metdata_port

p metadata_server
p metadata_port
updater = ProductUpdateById.new metadata_server, metadata_port
updater.update ARGV[0]

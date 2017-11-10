class BulkUpdateActive
  include Celluloid
  def initialize metadata_server, metadata_server_port=4568
    @part_rest_client = PartRestClient.new metadata_server, metadata_server_port
    @logger = ::Logger.new(STDOUT)
    @logger.level = ::Logger::INFO
    @logger.progname ="BulkUpdateActive"
    @product_api = TurboCassandra::API::Product.new
    @product_batch = TurboCassandra::API::Batch::Product.new
  end

  private
  def prepare_product_data part
    product = part
    @product_batch.remove_keys(product)
    @product_batch.prepare_interchanges(product)
    @product_batch.parse_critical_attributes(product)
    @product_batch.derive_name(product)
    product
  end

  def bulk_get_parts skus
    @part_rest_client.query_bulk skus
  end

  public
  def get_active_part_skus
    @part_rest_client.query_active
  end


  def run group
    parts = bulk_get_parts group
    parts.each do |part|
      product = prepare_product_data part
      @product_api.create product
      @logger.info "Updated [#{part['sku']}]"
    end
  end
end

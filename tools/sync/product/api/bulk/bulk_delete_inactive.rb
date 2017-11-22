class BulkDeleteInactive
  def initialize metadata_server, metadata_server_port=4568
    @part_rest_client = PartRestClient.new metadata_server, metadata_server_port
    @product_api = TurboCassandra::API::Product.new
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
    @logger.progname ="BulkDeleteInactive"
  end

  def run
    inactive_skus = @part_rest_client.query_inactive
    @logger.info "[#{inactive_skus.size}] Inactive Parts To Delete"
    inactive_skus.each do |sku|
      begin
        @product_api.delete sku
        @logger.info "Deleted [#{sku}]"
      rescue StandardError => e
        @logger.error "Not Deleted [#{sku}], Error [#{e.message}]"
      end
    end
    @logger.info "[#{inactive_skus.size}] Inactive Parts Deleteed"
  end
end
require_relative 'product_update_all_header'

unless ARGV[0].to_i > 0
  puts "Set Workers Number"
  exit 1
end

pool_size = ARGV[0].to_i
metadata_server = get_metdata_host
metadata_port = 4569

bulk_deleter = BulkDeleteInactive.new metadata_server, metadata_port
bulk_updater = BulkUpdateActive.pool size: pool_size, args: [metadata_server, metadata_port]

bulk_deleter.run
skus = bulk_updater.get_active_part_skus

batch_size = 100 * pool_size

skus.each_slice(batch_size) do |batch|
  futures = []
  batch.each_slice(100) do |group|
    futures.push resolve_future group, bulk_updater
  end
  until are_futures_ready?(futures)
    futures = remove_resolved_futures futures
  end
end


require_relative 'product_sync_all_header'

require_relative '../../sync_helper'
pool_size = ARGV[0].to_i || 4
metadata_server = "timms.turbointernational.com"
metadata_port = 4569
@worker = Worker.pool size: pool_size, args: [metadata_server, metadata_port]


(0..800).to_a.each do |time|

  ids = ((time *100 * pool_size)..(time * 100 *pool_size + 100 * pool_size -1)).to_a
  futures = []
  ids.each_slice(100) do |batch|
    futures.push resolve_future batch
  end
  until are_futures_ready?(futures)
    futures = remove_resolved_futures futures
  end
end

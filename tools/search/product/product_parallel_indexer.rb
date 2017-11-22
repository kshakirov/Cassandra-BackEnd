require_relative 'product_parallel_indexer_header'

pool_size = ARGV[0].to_i
pool_size ||=  4
elastic_host = get_elastic_host
index_name = get_index_name
product = TurboCassandra::API::Product.new

@worker = Worker.pool size: pool_size, args: [elastic_host, index_name]
done = false
paging_state = nil
counter = 0
until done do
  response = product.paginate paging_state, 1000 * pool_size
  products = response[:results]
  counter += products.size
  futures = []
  products.each_slice(1000) do |batch|
    futures.push resolve_future batch
  end
  until are_futures_ready?(futures)
    futures = remove_resolved_futures futures
  end
  paging_state = response[:paging_state]
  puts "Processed #{counter} Products"
  done = response[:last]
end
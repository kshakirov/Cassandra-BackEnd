require 'celluloid/current'
require 'celluloid/pool'
require_relative 'indexer_helper'

class Worker
  include Celluloid

  def initialize elastic_host, index_name
    @index_manager = TurboCassandra::ElasticIndex.new(elastic_host, index_name)
  end


  def run products
    start_time = Time.now
    @index_manager.bulk_add_product products
    elapsed_seconds = ((Time.now - start_time)).to_i
    puts "[#{products.size}]   [#{products.first['sku']}]   -  [#{products.last['sku']}]  Time [#{elapsed_seconds}]"
  end

end

def remove_resolved_futures futures
  futures.select do |future|
    if future.ready?
      future.value
      false
    else
      true
    end
  end
end

def are_futures_ready? unresolved_futures
  unresolved_futures.size == 0
end

def resolve_future products
  @worker.future.run (products)
end
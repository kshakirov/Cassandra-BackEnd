require 'celluloid/current'
require 'celluloid/pool'
require_relative '../../sync_helper'

class Worker
  include Celluloid

  def initialize metadata_server, port=4568
    @updater = TurboCassandra::Sync::Product::Rest.new(metadata_server, port)
  end

  def run skus
    start_time = Time.now
    @updater.update_specific_array skus
    elapsed_seconds = ((Time.now - start_time)).to_i
    puts "[#{skus.size}]   [#{skus.first}]   -  [#{skus.last}]  Time [#{elapsed_seconds}]"
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

def resolve_future skus
  @worker.future.run (skus)
end
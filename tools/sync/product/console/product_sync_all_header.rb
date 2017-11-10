require 'celluloid/current'
require 'celluloid/pool'
require_relative '../../sync_helper'



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

def resolve_future skus, worker
  worker.future.run (skus)
end
require_relative '../../sync_helper'
require_relative 'tcas_client'
require_relative '../api/product'
ENV['TURBO_MODE'] = "development"


updater = TurboCassandra::Sync::Product::Rest.new(TcasClient.new(get_tcas_host))

(110..720).to_a.each  do |time|
  start_time = Time.now
  ids = ((time *100)..(time * 100 + 99)).to_a
  updater.update_specific(ids)
  elapsed_seconds = ((Time.now - start_time)).to_i
  puts "[#{ids.size}]   [#{ids.first}]   -  [#{ids.last}]  Time [#{elapsed_seconds}]"
end
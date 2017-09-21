require_relative '../../sync_helper'
metadata_server = get_metdata_host
updater = TurboCassandra::Sync::Product::Rest.new(metadata_server)

(0..730).to_a.each  do |time|
  start_time = Time.now
  ids = ((time *100)..(time * 100 + 99)).to_a
  updater.update_specific_array(ids)
  elapsed_seconds = ((Time.now - start_time)).to_i
  puts "[#{ids.size}]   [#{ids.first}]   -  [#{ids.last}]  Time [#{elapsed_seconds}]"
end

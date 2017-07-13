require_relative 'indexer_helper'


elastic_host = get_elastic_host
index_name = get_index_name
product = TurboCassandra::API::Product.new
index_manager = TurboCassandra::ElasticIndex.new(elastic_host, index_name)

counter=1
start_time = Time.now
product.each {|p|

  begin
    if counter> 0
      index_manager.add_product p
    end
    elapsed_seconds = ((Time.now - start_time)).to_i
    puts " #{counter} : #{p['sku']}  Time Elapsed [#{elapsed_seconds.to_s}]"
    counter+=1
  rescue Exception => e
    puts "ERROR: Problematic Product #{p['sku']}"
    puts e.message
  end
}
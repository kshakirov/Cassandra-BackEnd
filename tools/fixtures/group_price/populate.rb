require_relative '../tools_helper'

group_price = TurboCassandra::GroupPrice.new
group_price_batch = TurboCassandra::GroupPriceBatch.new
product_hashes = YAML.load_stream(open(File.expand_path( '../data/all_products.yml', File.dirname(__FILE__))))

product_hashes.each_with_index do |product_hash, index|
  puts "Index " + index.to_s
 if product_hash.key? 'group_price' and  not  product_hash['group_price']['standardPrice'].nil?
   group_price_batch.prepare_group_price product_hash['group_price']
   group_price.insert product_hash['group_price']
 end
end
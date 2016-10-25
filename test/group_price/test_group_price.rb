require_relative 'test_helper'
require_relative 'test_helper'

group_price = TurboCassandra::GroupPrice.new
group_price_batch = TurboCassandra::GroupPriceBatch.new
product_hashes = YAML.load_stream(open("../all_products.yml"))

product_hashes.each_with_index do |product_hash, index|
 if product_hash.key? 'group_price' and  not  product_hash['group_price']['standardPrice'].nil?
   group_price_batch.prepare_group_price product_hash['group_price']
   p  product_hash['sku']
   group_price.insert product_hash['group_price']
 end
end
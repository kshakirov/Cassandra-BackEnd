require_relative '../tools_helper'

featured_product_api = TurboCassandra::API::FeaturedProduct.new
new_product_api = TurboCassandra::API::NewProduct.new
product_api = TurboCassandra::API::Product.new
featured_products = [
    {sku: 48635},
    {sku: 62958},
    {sku: 63015},
    {sku: 64142}
]

products = featured_products.map do |fp|
  product_api.find_by_sku fp[:sku]
end

count =0
products = products.map do |p|
  count += 1
  {
      'sku' => p['sku'],
      'part_number'=> p['part_number'],
      'visible'=> true,
      'ord'=> count

  }
end

products.each{|p| featured_product_api.create p}

p products

new_products = [
    {sku: 62923},
    {sku: 65019},
    {sku: 64958},
    {sku: 62923}
]

products = new_products.map do |fp|
  product_api.find_by_sku fp[:sku]
end

count =0
products = products.map do |p|
  count += 1
  {
      'sku' => p['sku'],
      'part_number'=> p['part_number'],
      'visible'=> true,
      'ord'=> count

  }
end

products.each{|p| new_product_api.create p}
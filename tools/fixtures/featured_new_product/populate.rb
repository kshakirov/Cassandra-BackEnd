require_relative 'populate_helper'

featured_product_manager = TurboCassandra::FeaturedProduct.new
new_product_manager = TurboCassandra::NewProduct.new
featured_products = [
    {sku: 47738},
    {sku: 42763},
    {sku: 43746},
    {sku: 45069}
]

featured_products.each{|fp| featured_product_manager.insert fp }

new_products = [
    {sku: 47820},
    {sku: 47740},
    {sku: 47851},
    {sku: 43756}
]

new_products.each{|np| new_product_manager.insert np }
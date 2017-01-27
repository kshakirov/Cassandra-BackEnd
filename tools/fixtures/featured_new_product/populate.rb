require_relative '../tools_helper'

featured_product_manager = TurboCassandra::FeaturedProduct.new
new_product_manager = TurboCassandra::NewProduct.new
featured_products = [
    {sku: 62923},
    {sku: 65019},
    {sku: 64958},
    {sku: 64690}
]

featured_products.each{|fp| featured_product_manager.insert fp }

new_products = [
    {sku: 62923},
    {sku: 65019},
    {sku: 64958},
    {sku: 62923}
]

new_products.each{|np| new_product_manager.insert np }
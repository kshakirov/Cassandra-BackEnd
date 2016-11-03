require_relative 'populate_helper'

cart = TurboCassandra::Cart.new
product_model = TurboCassandra::Product.new
group_price_model = TurboCassandra::GroupPrice.new
product = product_model.find 45068
price =  group_price_model.find 45068
p price
p product

cart.add_product 487, product.first, 120, 1
47738
product = product_model.find 47738
cart.add_product 487, product.first, 150, 2

cart.delete_product 487, 47738
require_relative '../current_helper'
cart_api = TurboCassandra::API::Cart.new
cart_api.all.each do |cart|
  cart['subtotal'] =  cart['subtotal'].round(2)  unless cart['subtotal'].nil?
  cart_api.update cart
end



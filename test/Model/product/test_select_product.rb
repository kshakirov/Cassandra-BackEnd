require_relative 'test_helper'

product = TurboCassandra::Product.new


4.times do
  pp = product.find 45069

  p pp
end



require_relative 'test_helper'

f = TurboCassandra::FeaturedProduct.new

p f.all

n = TurboCassandra::NewProduct.new

p n.all
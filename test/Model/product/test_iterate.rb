require_relative 'test_helper'

product = TurboCassandra::Product.new

product.each{|r|
    p r['sku']
}
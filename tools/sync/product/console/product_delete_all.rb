require_relative '../../sync_helper'


puts "You are to delete all products, are you sury, NO/YES"
answer = gets
if answer.chop == 'YES'
  puts answer
  product = TurboCassandra::API::Product.new

  (0..78000).to_a.each do |id|

    prd = product.find id
    unless prd.nil?
      puts "Deleting Product [ #{prd.sku}]"
      product.delete prd.sku
    end
  end
else
  puts "You must enter exactly YES if you want to delete"
end
require_relative '../../sync_helper'


puts "You are to delete all products, are you sury, NO/YES"
answer = gets
if answer.chop == 'YES'
  puts answer
  product = TurboCassandra::API::Product.new

  (43628..78000).to_a.each do |id|

    prd = product.find id
    unless prd.nil?
      puts "Deleting Product [ #{prd.sku}]"
      begin
      product.delete prd.sku if prd.sku
      rescue StandardError => se
        puts se.message
      end
    end
  end
else
  puts "You must enter exactly YES if you want to delete"
end
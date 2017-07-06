ENV['TURBO_MODE'] ='development'

require_relative '../../current_helper'

def populate_prod_part_num products
  products.each do |p|

    ppn = TurboCassandra::Model::ProductPartNumber.new part_number: p['part_number'],
                                                       sku: p['sku']
    begin
      ppn.save
      puts "Added Sku [#{p['sku']}] PartNumber [#{p['part_number']}]"
    rescue
      puts "ERROR:  Sku [#{p['sku']}]"
    end
  end
end

product_api = TurboCassandra::API::Product.new
paging_state = nil
page_size = 10
avail = true
while avail do
  result = product_api.paginate paging_state, page_size
  paging_state = result[:paging_state]
  products = result[:results]
  populate_prod_part_num(products)
  avail = !result[:last]
end

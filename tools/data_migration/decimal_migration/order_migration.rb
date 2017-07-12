require_relative '../current_helper'
# order_api = TurboCassandra::API::Order.new
# order_api.all.each do |order|
#   puts "Order to process #{order['order_id']}"
#   begin
#     order['grand_total'] = order['grand_total'].round(2)
#     order['grand_total_invoiced'] = order['grand_total_invoiced'].round(2)
#     order['shipping_handling']=order['shipping_handling'].round(2)
#     order['subtotal']=order['subtotal'].round(2)
#     order_api.insert order
#   rescue
#     puts "Problem with this order"
#   end
# end


require 'bigdecimal'

class BigDecimal

  def to_json(options = nil) #:nodoc:
    if finite?
      self.to_s
    else
      NilClass::AS_JSON
    end
  end
end

d =  BigDecimal.new(12345.343434, 10).round(10,BigDecimal::EXCEPTION_NaN)
hash = {
    number: d
}

p hash.to_json
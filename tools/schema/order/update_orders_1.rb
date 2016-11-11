require_relative '../tools_helper'

columns = %W(payment_method  shipping_method   special_instructions   customer_purchase_order
subtotal  shipping_handling  grand_total )

types = %W( varchar  varchar   varchar   varchar  double  double  double)

columns.each_with_index do |column, index|
  puts "#{column} #{types[index]}"
  cql = %Q(ALTER TABLE orders ADD #{column} #{types[index]} )
  execute_lazy(cql, [])
end


require_relative '../tools_helper'

columns = %W(updated_at grand_total_invoiced status )

types = %W( timestamp  double   varchar )

columns.each_with_index do |column, index|
  puts "#{column} #{types[index]}"
  cql = %Q(ALTER TABLE orders ADD #{column} #{types[index]} )
  execute_lazy(cql, [])
end
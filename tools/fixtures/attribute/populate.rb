require_relative 'populate_helper.rb'

attribute_batch = TurboCassandra::AttributeBatch.new
attribute = TurboCassandra::Attribute.new
attrs = read_attributes_from_file

attrs.each do |attr|
  puts "Attribute code  [#{attr['code']}]"
  properties = attribute_batch.adopt_hash attr
  attribute.insert properties
end

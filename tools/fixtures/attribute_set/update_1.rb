require_relative '../tools_helper'

attr_set = TurboCassandra::Model::AttributeSet.new
attributes = read_attributes_from_file
attributes.each do |a|
  attribute_set_code = a['attribute_set'].gsub(' ','').underscore
  attribute_code =  a['code']
  attr_set.update_attribute_list(attribute_set_code, attribute_code)
end
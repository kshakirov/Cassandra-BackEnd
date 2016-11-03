require_relative 'populate_helper'

attr_set = TurboCassandra::AttributeSet.new
sets = read_attribute_sets_from_file
sets.each do |s|
  attr_set.insert({ :code => s.gsub(' ','').underscore, :name => s})
end
require_relative 'test_helper.rb'
attribute = TurboCassandra::Attribute.new
attr =  attribute.find "manufacturer"
p attr


require_relative 'test_helper'

menu_manager = TurboCassandra::MenuBackEnd.new
 menu_manager.get_manufacturers

 menu_manager.get_parts

 menu_manager.get_currencies

pps =  menu_manager.get_new_product
 pps

filters = menu_manager.get_filters
 filters = JSON.parse filters
p filters


require_relative '../tools_helper'

currency_manager = TurboCassandra::Currency.new
currencies =  [
         {
             code: 'EUR', base: false, rate: 0.87
         },
         {
             code: 'USD', base: false, rate: 1.0
         }
     ]
currencies.each{|c| currency_manager.insert c}
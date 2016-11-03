require_relative 'test_helper'

currency_manager = TurboCassandra::Currency.new

p currency_manager.all
require './backend.rb'
require './customer.rb'

run Rack::URLMap.new({
                         '/' => Public,
                         '/customer' => Customer
                     })
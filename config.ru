require './backend.rb'
require './customer.rb'

#\ -w -p 4700
run Rack::URLMap.new({
                         '/' => Public,
                         '/customer' => Customer
                     })

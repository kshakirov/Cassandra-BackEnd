require './backend.rb'
require './customer.rb'
require './admin.rb'

#\ -w -p 4700
run Rack::URLMap.new({
                         '/' => Public,
                         '/customer' => Customer,
                         '/admin' =>  Admin
                     })

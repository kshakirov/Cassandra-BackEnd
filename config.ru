require_relative 'rest/turbo/backend'
require_relative 'rest/turbo/customer'
require_relative 'rest/turbo/admin'

#\ -w -p 4700
run Rack::URLMap.new({
                         '/' => Public,
                         '/customer' => Customer,
                         '/admin' =>  Admin
                     })

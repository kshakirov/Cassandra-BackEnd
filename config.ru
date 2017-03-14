require_relative 'rest/turbo/backend'
require_relative 'rest/turbo/customer'
require_relative 'rest/turbo/admin'
require_relative 'rest/turbo/webapi'

#\ -w -p 4700
run Rack::URLMap.new({
                         '/' => Public,
                         '/customer' => Customer,
                         '/admin' =>  Admin,
                         '/V1' =>   WebAPI
                     })

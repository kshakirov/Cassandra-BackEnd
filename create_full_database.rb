#CREATE KEYSPACE turbo_test WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '3'}  AND durable_writes = true;

require 'rake'
require 'rake/task'
ENV['TURBO_MODE'] = 'test'
puts  ENV['TURBO_MODE']
rake = Rake.application
rake.init
rake.load_rakefile
rake['db:setup:all'].invoke()
rake['db:migrate:all'].invoke()
rake['db:populate:all'].invoke()

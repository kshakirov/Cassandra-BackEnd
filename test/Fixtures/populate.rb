require 'rake'
require 'rake/task'
Dir.chdir("../../")
ENV['TURBO_MODE'] = 'test'
puts  ENV['TURBO_MODE']
Rake::Task['db:setup:base'].invoke
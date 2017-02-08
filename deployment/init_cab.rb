require 'etcd'
require 'yaml'


def get_production_db_nodes ips, settings
  settings['production']['hosts']=ips
  p settings
end



client = Etcd.client
puts "connecnting"
client.set('/nodes/n1', value: 1)
p client.get('/foo').value
  response  =client.watch("/test", {timeout: 3000}).value
  settings = YAML.load_file(File.expand_path(  "../config/database.yml", File.dirname(__FILE__)))
  get_production_db_nodes(['10.1.1.1','10.1.1.1', '10.1.1.1' ], settings)
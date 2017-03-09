require_relative 'indexer_helper'
elastic_host = get_elastic_host

index_manager = TurboCassandra::ElasticIndex.new(elastic_host, "")

YAML.load_stream(File.open(File.expand_path( '../data/all_applications.yml', File.dirname(__FILE__)))) do |document|
  index_manager.add_application document
end


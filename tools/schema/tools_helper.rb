require_relative '../../lib/Model/turbo_cluster'
require 'json'
require 'yaml'
require 'cassandra'
require 'active_support'

def execute_lazy cql, args
  session = TurboCassandra::TurboCluster.get_session
  statement = session.prepare(cql)
  session.execute(statement, arguments: args, consistency: :one)
end
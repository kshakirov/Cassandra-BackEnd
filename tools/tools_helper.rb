require_relative '../lib/tools/Model/attribute'
require_relative '../lib/tools/Model/turbo_cluster'
require 'json'
require 'yaml'
require 'cassandra'
require 'active_support'

# def execute cql, keyspace='trash1'
#   cluster = Cassandra.cluster(hosts: ['10.1.3.15', '10.1.3.16', '10.1.3.17'])
#   session = cluster.connect(keyspace)
#   session.execute("USE #{keyspace}")
#
#   begin
#     session.execute(cql)
#   rescue Cassandra::Errors::AlreadyExistsError => e
#     p ['already exists', e.keyspace, e.table]
#   end
# end


def execute_lazy cql, args
  session = TurboCassandra::TurboCluster.get_session
  statement = session.prepare(cql)
  session.execute(statement, arguments: args, consistency: :one)
end
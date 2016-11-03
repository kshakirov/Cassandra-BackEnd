require_relative "../tools_helper"
keyspace = TurboCassandra::TurboCluster.get_keyspacse
cql = "CREATE KEYSPACE #{keyspace} WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '3'}"
execute_lazy(cql, [])

require_relative '../tools_helper'
column = 'critical'
type = 'boolean'
cql = %Q(ALTER TABLE attribute_sets ADD #{column} #{type} )
execute_lazy(cql, [])

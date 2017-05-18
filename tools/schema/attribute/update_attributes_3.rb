require_relative '../tools_helper'
column = 'entity'
type= 'text'
cql = %Q(ALTER TABLE attributes ADD #{column} #{type} )
execute_lazy(cql, [])
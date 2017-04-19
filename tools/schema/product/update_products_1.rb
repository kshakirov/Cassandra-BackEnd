require_relative '../tools_helper'
column = 'cartridges'
type = 'frozen <list<map<text,text>>> '
cql = %Q(ALTER TABLE products ADD #{column} #{type} )
execute_lazy(cql, [])
require_relative '../tools_helper'

cql = %Q(CREATE INDEX set_name ON attributes (attribute_set))
execute_lazy(cql, [])
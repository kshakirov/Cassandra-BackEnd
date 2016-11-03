require_relative '../tools_helper'

cql = "CREATE TABLE attribute_sets (code  text PRIMARY KEY, name text,  attributes list<text>)"
 execute_lazy cql,[]
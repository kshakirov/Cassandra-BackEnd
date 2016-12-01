require_relative '../tools_helper'
cql = %Q(ALTER TABLE  products ADD application_detail  text)
execute_lazy cql, []
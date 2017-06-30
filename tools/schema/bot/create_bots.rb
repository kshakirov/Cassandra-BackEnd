require_relative '../tools_helper'

cql = %Q(CREATE TABLE  bots
        (
            id bigint  Primary Key,
         ))
execute_lazy(cql, [])
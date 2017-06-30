require_relative '../../tools_helper'

cql = %Q(CREATE TABLE  product_ranks
        (
            sku bigint  Primary Key,
            times bigint
         ))
execute_lazy(cql, [])
require_relative '../../tools_helper'

cql = %Q(CREATE TABLE  product_part_numbers
        (
            part_number text  Primary Key,
            sku bigint
         ))
execute_lazy(cql, [])
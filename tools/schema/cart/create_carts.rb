require_relative '../tools_helper'

cql = %Q(CREATE TABLE  carts
        (
            id int Primary Key,
            customer_id bigint,
            currency text,
            subtotal decimal,
            size int,
            items frozen <map<bigint, map<text,text>>>))
execute_lazy cql, []
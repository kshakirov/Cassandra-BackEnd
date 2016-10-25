require_relative '../tools_helper'

cql = %Q(CREATE TABLE  carts
        (
            id int Primary Key,
            customer_id bigint,
            currency int,
            subtotal double,
            size int,
            items frozen <list<map<text,text>>>))
execute cql
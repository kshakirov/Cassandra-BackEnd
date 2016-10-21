require_relative '../tools_helper'

cql = %Q(CREATE TABLE  orders
        (
            order_id text Primary Key,
            customer_id text,
            data map<text,text>,
            products frozen <list<map<text,text>>>))
execute cql
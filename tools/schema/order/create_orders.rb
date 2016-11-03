require_relative '../tools_helper'

cql = %Q(CREATE TABLE  orders
        (
            order_id bigint Primary Key,
            customer_id bigint,
            data map<text,text>,
            billing_address map<text,text>,
            shipping_address map<text,text>,
            products frozen <list<map<text,text>>>))
execute_lazy cql, []
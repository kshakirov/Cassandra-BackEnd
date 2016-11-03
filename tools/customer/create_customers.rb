require_relative '../tools_helper'

cql = %Q(CREATE TABLE  customers
        (
            id  bigint PRIMARY KEY,
            firstname text,
            lastname text,
            email text,
            password text,
            group_id text,
            prefix text,
            suffix text,
            default_billing_address map <text,text>,
            default_shipping_address map <text,text>))
execute_lazy cql, []
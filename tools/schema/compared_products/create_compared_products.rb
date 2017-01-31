require_relative '../tools_helper'

cql = %Q(CREATE TABLE  compared_products
        (
            customer_id bigint,
            product bigint,
            date timestamp,
            Primary Key(customer_id, product)))
execute_lazy cql, []
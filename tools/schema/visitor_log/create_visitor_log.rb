require_relative '../tools_helper'

cql = %Q(CREATE TABLE  visitor_logs
        (
            visitor_id bigint,
            date timestamp,
            id timeuuid,
            ip inet,
            customer_id bigint,
            product bigint, Primary Key(visitor_id, date, id, ip)))
execute_lazy cql, []

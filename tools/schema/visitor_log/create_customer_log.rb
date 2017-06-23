require_relative '../tools_helper'

cql = %Q(CREATE TABLE  customer_logs
        (
            customer_id bigint,
            date timestamp,
            id timeuuid,
            ip inet,
            visitor_id bigint,
            product bigint, Primary Key(customer_id, date, id, ip)) WITH CLUSTERING ORDER BY (date DESC, id DESC, ip ASC)
)
execute_lazy cql, []

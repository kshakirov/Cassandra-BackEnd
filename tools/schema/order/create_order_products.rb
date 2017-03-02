require_relative '../tools_helper'

cql = %Q(CREATE TABLE  order_products
        (
            order_id bigint,
            sku bigint ,
            name text,  Primary Key(order_id, sku)))
  execute_lazy cql, []
require_relative '../tools_helper'

cql = %Q(CREATE TABLE  product_orders
        (
          sku bigint ,
          order_id bigint,  Primary Key(sku, order_id)))
execute_lazy cql, []
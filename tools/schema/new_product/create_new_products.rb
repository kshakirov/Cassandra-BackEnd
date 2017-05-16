require_relative '../tools_helper'

cql = %Q(CREATE TABLE  new_products
        (
            sku  bigint Primary Key,
            visible boolean,
            ord int,
            part_number text))
execute_lazy cql, []


cql = %Q(CREATE TABLE  new_product_orders
        (
            sku  bigint ,
            visible boolean,
            cluster int,
            ord int,
            part_number text,
          PRIMARY KEY (cluster, ord))  WITH CLUSTERING ORDER BY (ord ASC))
execute_lazy cql, []
cql = %Q(CREATE INDEX new_visible ON new_product_orders (visible))
execute_lazy cql, []

require_relative '../tools_helper'

cql = %Q(CREATE TABLE group_prices
        (
           sku  bigint Primary Key,
            standardPrice  double,
            prices map<text,double>,
            discount double))
execute_lazy cql, []
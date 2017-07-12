require_relative '../tools_helper'

cql = %Q(CREATE TABLE group_prices
        (
           sku  bigint Primary Key,
            standardPrice  decimal,
            prices map<text,decimal>,
            discount decimal))
execute_lazy cql, []
require_relative '../tools_helper'

cql = %Q(CREATE INDEX customer_id ON orders (customer_id))
execute cql
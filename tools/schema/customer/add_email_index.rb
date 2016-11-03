require_relative '../tools_helper'

cql = %Q(CREATE INDEX customer_email ON customers (email))
execute_lazy cql, []
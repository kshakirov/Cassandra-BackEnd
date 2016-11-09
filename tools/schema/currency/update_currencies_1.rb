require_relative '../tools_helper'

cql = %Q(UPDATE  currencies
                SET base=? WHERE code=?)
execute_lazy cql, [true, 'USD']
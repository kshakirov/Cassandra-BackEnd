require_relative '../tools_helper'

cql = %Q(INSERT INTO  currencies (code, base, rate) VALUES (?,?,?))
execute_lazy cql, ['GBP', false, 0.81]
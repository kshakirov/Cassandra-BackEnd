require_relative '../tools_helper'

cql = %Q(CREATE TABLE  currencies
        (
            code  text PRIMARY KEY,
            base  boolean,
            rate double
           ))
execute_lazy cql, []


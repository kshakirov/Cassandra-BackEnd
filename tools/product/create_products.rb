require_relative '../tools_helper'

cql = %Q(CREATE TABLE  products
        (
            sku  bigint PRIMARY KEY,
            name text,
            manufacturer text,
            part_number text,
            description text,
            part_type text,
            has_ti_interchange boolean,
            has_ti_chra boolean,
            turbo_model list<text>,
            turbo_type list<text>,
            has_foreign_interchange boolean,
            critical_decimal map<text,double>,
            critical_integer map<text,int>,
            critical_enum map<text,text>))
execute_lazy cql,[]
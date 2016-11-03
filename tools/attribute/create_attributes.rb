require_relative '../tools_helper'

cql = %Q(CREATE TABLE  attributes
        (
            code text Primary Key,
            attribute_set text,
            label text, type text,
            tolerance int,
            is_visible_in_list int,
            is_critical_dimension int,
            searchable int,
            filterable int,
            comparable int,
            is_filterable_in_search int,
            scale int,
            length int,
            parent_id text,
            unit text,
            seq_num int,
            options list <text>))
execute_lazy(cql, [])
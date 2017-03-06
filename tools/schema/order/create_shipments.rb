require_relative '../tools_helper'

cql = %Q(CREATE TABLE  shipments
        (   order_id bigint,
            id bigint,
            customer_id bigint,
            created_at timestamp,
            updated_at timestamp,
            order_date timestamp,
            items frozen <list<map<text,text>>>,
            total_qty int,
            total_weight int,
            shipment_status text,
            shipping_label text,
            customer_data map<text,text>,
            billing_address map<text,text>,
            shipping_address map<text,text>,
            customer map<text,text>,
            Primary Key (order_id, id) ))
execute_lazy cql, []
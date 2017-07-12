require_relative '../tools_helper'

cql = %Q(CREATE TABLE  orders
        (
            order_id bigint PRIMARY KEY,
            billing_address map<text, text>,
            currency_code text,
            customer_id bigint,
            customer_purchase_order text,
            data map<text, text>,
            grand_total decimal,
            grand_total_invoiced decimal,
            payment_method text,
            products frozen<list<frozen<map<text, text>>>>,
            shipping_address map<text, text>,
            shipping_handling decimal,
            shipping_method text,
            special_instructions text,
            status text,
            subtotal decimal,
            updated_at timestamp))
execute_lazy cql, []

cql = %Q(CREATE INDEX customer_id ON orders (customer_id))
execute_lazy cql, []
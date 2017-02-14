require_relative '../tools_helper'

cql = %Q(CREATE TABLE  message_logs
        (
            sender_email text,
            recepient_email text,
            date timestamp,
            id uuid,
            message text, Primary Key(sender_email, recepient_email, date, id)))
execute_lazy cql, []

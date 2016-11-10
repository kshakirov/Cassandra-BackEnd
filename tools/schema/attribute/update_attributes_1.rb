require_relative '../tools_helper'

turbo_types =JSON::parse(File.read(File.join(__dir__, 'turbo_types.json')))

cql = %Q(Insert into   attributes  (code, attribute_set, label, options) values
        (
            ?,
            ?,
            ?,
            ?)
)
execute_lazy cql,['turbo_type',  'default',  'Turbo Type',  turbo_types]


require_relative '../tools_helper'


turbo_models = JSON::parse(File.read(File.join(__dir__, 'turbo_models.json')))
cql = %Q(Insert into   attributes  (code, attribute_set, label, options) values
        (
            ?,
            ?,
            ?,
            ?)
)

execute_lazy cql, [ 'turbo_model',
                    'default',
                    'Turbo Model', turbo_models]
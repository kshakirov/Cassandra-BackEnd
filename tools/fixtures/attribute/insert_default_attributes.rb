require_relative '../tools_helper'

attribute = TurboCassandra::API::Attribute.new

manufacturer = {
    options: [
        "Garrett",
        "Holset",
        "Mitsubishi",
        "I.H.I.",
        "KKK",
        "Schwitzer",
        "Toyota",
        "Komatsu",
        "Hitachi",
        "Turbo International",
        "Rotomaster"
    ],
    code: 'manufacturer',
    attribute_set: 'default',
    label: 'Manufacturer',
    type: 'int',
    entity: 'product'
}

part = {
    options: [
        "Cartridge",
        "Turbo",
        "Backplate",
        "Bearing Housing",
        "Compressor Wheel",
        "Heatshield",
        "Nozzle Ring",
        "Turbine Wheel",
        "Actuator",
        "Backplate \/ Sealplate",
        "Bearing Spacer",
        "Bolt Screw",
        "Carbon Seal",
        "Clamp",
        "Compressor Cover",
        "Fitting",
        "Gasket",
        "Heatshield \/ Shroud",
        "Journal Bearing",
        "Journal Bearing Spacer",
        "Kit",
        "Miscellaneous Minor Components",
        "Nut",
        "O Ring",
        "Oil Deflector",
        "Pin",
        "Piston Ring",
        "Plug",
        "Retaining Ring",
        "Seal Plate",
        "Spring",
        "Thrust Bearing",
        "Thrust Collar",
        "Thrust Parts",
        "Thrust Spacer",
        "Thrust Washer",
        "Turbine Housing",
        "Washer",
        "Gasket Kit"
    ],
    code: 'part',
    attribute_set: 'default',
    label: 'Part Type',
    type: 'int',
    entity: 'product'
}

attribute.create manufacturer
attribute.create part


turbo_types =JSON::parse(File.read(File.join(__dir__, 'turbo_types.json')))
turbo_type = {
    options: turbo_types,
    code: 'turbo_type',
    attribute_set: 'default',
    label: 'Turbo Type',
    type: 'int',
    entity: 'product'
}

attribute.create turbo_type

turbo_models = JSON::parse(File.read(File.join(__dir__, 'turbo_models.json')))

turbo_model = {
    options: turbo_models,
    code: 'turbo_model',
    attribute_set: 'default',
    label: 'Turbo Model',
    type: 'int',
    entity: 'product'
}

attribute.create turbo_model

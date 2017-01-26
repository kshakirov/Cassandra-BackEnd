require_relative '../tools_helper'

manufacturers = [
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
]



cql = %Q(Insert into   attributes  (code, attribute_set, label, options) values
        (
            ?,
            ?,
            ?,
            ?)
)
execute_lazy cql,['manufacturer',  'default',  'Manufacturer',  manufacturers]


part_types = [
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
]





cql = %Q(Insert into   attributes  (code, attribute_set, label, options) values
        (
            ?,
            ?,
            ?,
            ?)
)

execute_lazy cql, [ 'part',
                    'default',
                    'Part Tupe', part_types]
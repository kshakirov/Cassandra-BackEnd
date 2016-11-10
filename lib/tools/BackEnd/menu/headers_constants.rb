module TurboCassandra
  def  self.initialize_headers
    [
        {
            "name": "TI PART",
            "code": "ti_part",
            "type": "string"
        },
        {
            "name": "OE REF",
            "code": "oe_ref_urls",
            "type": "string"
        },
        {
            "name": "Description ",
            "code": "description",
            "type": "string"
        },
        {
            "name": "Turbo Type",
            "code": "turbo_type",
            "type": "string"
        },
        {
            "name": "Ref Manufacturer ",
            "code": "manufacturer",
            "type": "string"
        }
    ]
  end



  def  self.initialize_critical_headers
    [
        {
            "name": "TI PART",
            "code": "ti_part",
            "type": "string"
        },
        {
            "name": "OE REF",
            "code": "oe_ref_urls",
            "type": "string"
        }
    ]
  end


  def  self.initialize_critical_sorters
    [
        {
            "name": "TI PART",
            "code": "ti_part.ti_part_number",
            "type": "string"
        },
        {
            "name": "OE REF",
            "code": "oe_ref_urls.part_number",
            "type": "string"
        },
        {
            "name": "PRICE",
            "code": "price.5",
            "type": "int"
        }
    ]
  end

  def self.initialize_sorters
    [
        {
            "name": "TI PART",
            "code": "ti_part.ti_part_number",
            "type": "string"
        },
        {
            "name": "OE REF",
            "code": "oe_ref_urls.part_number",
            "type": "string"
        },
        {
            "name": "MANUFACTURER",
            "code": "manufacturer.code",
            "type": "int"
        },
        {
            "name": "PRICE",
            "code": "price.5",
            "type": "int"
        }
    ]
  end

  def self.initialize_filters
    [
        {
            "name": "Turbo Type",
            "code": "turbo_type",
            "type": "int",
            "options": [

            ]
        },
        {
            "name": "Manufacturer ",
            "code": "manufacturer",
            "type": "int",
            "options": [

            ]
        },
        {
            "name": "Part Type",
            "code": "part_type",
            "type": "int",
            "options": [

            ]
        }
    ]
  end

end
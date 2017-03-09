module TurboCassandra
  class EsProductMapping
    def initialize
      @body = {product: {
          properties: {
          }
      }
      }
    end

    def _process_standard_attr(name)
      attr = @body[:product][:properties]
      attr[name.to_sym] = {}
      attr[name.to_sym][:properties] = {
          code: {type: 'integer'},
          name: {type: 'string', index: "not_analyzed"}
      }
    end

    def _create_standard_attr_mapping
      ['turbo_type', 'turbo_model', 'manufacturer'].each do |p|
        _process_standard_attr p
      end
    end

    def _create_oe_ref_attr_mapping
      @body[:product][:properties][:oe_ref_urls] = {
          properties: {
              product_url: {
                  type: 'string', index: 'not_analyzed'},
              part_number: {
                  type: 'string', index: 'not_analyzed'},
              part_number_clean: {
                  type: 'string', index: 'not_analyzed'}
          }
      }
    end

    def _create_ti_part_mapping
      @body[:product][:properties][:ti_part] = {properties: {
          ti_url: {
              type: 'string',
              index: 'not_analyzed'
          }, ti_part_number: {
              type: 'string',
              index: 'not_analyzed'
          }, ti_part_number_clean: {
              type: 'string',
              index: 'not_analyzed'
          },
          ti_part: {
              type: 'string',
              index: 'not_analyzed'
          }
      }
      }
    end

    def _create_critical_mapping critical_attributes
      critical_attributes.each do |attribute|
        type = attribute['options']['type'];
        if type == 'decimal'
          @body[:product][:properties][attribute['code'].to_sym] = {properties: {
              value: {
                  properties: {
                      inches: {
                          type: 'double'
                      },
                      centimeters: {
                          type: 'double'
                      }
                  }
              },
              scale: {
                  type: 'integer'
              },
              length: {
                  type: 'integer'
              },
              tolerance: {
                  properties: {
                      inches: {
                          type: 'double'
                      },
                      centimeters: {
                          type: 'double'
                      },
                      scale: {
                          type: 'integer'
                      }
                  }
              },
              units: {
                  type: 'string'
              },
              applicable: {
                  type: 'boolean'
              }
          }
          }
        end
      end
    end

    def create
      _create_standard_attr_mapping
      _create_oe_ref_attr_mapping
      _create_ti_part_mapping
      @body
    end

    def create_criticals attrs
      _create_critical_mapping attrs
      @body
    end

  end
end
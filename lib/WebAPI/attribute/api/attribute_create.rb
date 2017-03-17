module TurboCassandra
  module WebAPI
    module Attribute
      module AttributeCreate


        def bool_2_i bool
          bool ? 1: 0
        end

        def i_2_bool i
          i == 1 ? true: false
        end

        def process_options attribute
          opts = attribute['options']
          if not opts.nil? and opts.class.name =='Array'
            opts.map { |opt| opt['label'] }
          end
        end

        def add_options attribute_data, attribute
          options = process_options attribute
          unless options.nil?
            attribute_data[:options] = options
          end
        end

        def process_request attribute
          {
              code: attribute['attribute_code'],
              filterable: bool_2_i(attribute['isFilterable'] ),
              is_filterable_in_search: bool_2_i(attribute['isFilterableInSearch']),
              is_visible_in_list: bool_2_i(attribute['isVisibleInGrid']),
              label: attribute['defaultFrontendLabel'],
              searchable: 0,
              type: attribute['backendType']
          }
        end

        def respond attribute_data
          attribute_data[:attributeCode] = attribute_data[:code]
          attribute_data[:attribute_code] = attribute_data[:code]
          attribute_data[:attributeId] = attribute_data[:code]
          attribute_data
        end

        def _create body
          attribute_data = process_request body['attribute']
          add_options(attribute_data, body['attribute'])
          @attribute_api.create attribute_data
          respond attribute_data
        end
      end
    end
  end
end
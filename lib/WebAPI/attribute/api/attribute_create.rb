module TurboCassandra
  module WebAPI
    module Attribute
      module AttributeCreate
        private

        def bool_2_i bool
          case bool
            when true,             1
            when false,        0
            else
              0
          end
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
              code: attribute['customAttributes'][0]['attributeCode'],
              filterable: bool_2_i(attribute['isFilterable'] ),
              is_filterable_in_search: bool_2_i(attribute['isFilterableInSearch']),
              is_visible_in_list: bool_2_i(attribute['isVisibleInGrid']),
              label: attribute['defaultFrontendLabel'],
              searchable: 0,
              type: attribute['backendType']
          }
        end

        def _create body
          attribute_data = process_request body['attribute']
          add_options(attribute_data, body['attribute'])
          @attribute_api.create attribute_data
          attribute_data
        end
      end
    end
  end
end
module TurboCassandra
  module WebAPI
    module Attribute
      module AttributeGet
        private
        def prepare_options attribute
          opts = attribute['options']
          if not opts.nil? and opts.class.name =='Array'
            opts.map { |opt| { label: opt} }
          end
        end

        def prepare_response attribute
          {
              customAttributes: [{
                                     attributeCode: attribute['code']
                                 }],
              isFilterable: attribute['filterable'],
              isFilterableInSearch: attribute['is_filterable_in_search'],
              isVisibleInGrid: attribute['is_visible_in_list'],
              defaultFrontendLabel: attribute['label'],
              backendType: attribute['type'],
              options: prepare_options(attribute)
          }
        end

        def _get attribute_code
          attribute = @attribute_api.find attribute_code
          if  not attribute.nil? and attribute.first
            prepare_response(attribute.first)
          else

          end
        end
      end
    end
  end
end

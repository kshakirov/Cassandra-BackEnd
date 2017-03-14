module TurboCassandra
  module WebAPI
    module Attribute
      class Attribute
        include AttributeCreate
        attr_accessor :attribute_api
        def initialize
          @attribute_api = TurboCassandra::API::Attribute.new
        end

        def create body
            body = JSON.parse body
            _create(body)
        end

        def update attribute_code

        end

        def delete attribute_code

        end

        def get attribute_code

        end
      end
    end
  end
end
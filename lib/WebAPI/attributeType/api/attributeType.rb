module TurboCassandra
  module WebAPI
    module AttributeType
      class AttributeType
        def initialize

        end

        def get
          [
              {
                  "value": "double",
                  "label": "Decimal",
                  "extensionAttributes": {}
              },
              {
                  "value": "int",
                  "label": "Integer",
                  "extensionAttributes": {}
              },
              {
                  "value": "text",
                  "label": "Text",
                  "extensionAttributes": {}
              },
          ]
        end
      end
    end
  end
end
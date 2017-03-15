module TurboCassandra
  module API
    class Attribute
      public
      def initialize
        @attribute_model = TurboCassandra::Model::Attribute.new
      end
      def find_all
        @attribute_model.find_all
      end
      def find code
        @attribute_model.find(code)
      end
      def find_by_set_name name
        @attribute_model.find_by_set_name name
      end
      def all
        @attribute_model.all
      end
      def find_by_codes codes
        @attribute_model.find_by_codes codes
      end

      def create attribute_data
        @attribute_model.insert attribute_data
      end
      def delete code
          @attribute_model.delete code
      end
    end
  end
end
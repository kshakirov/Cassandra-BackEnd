module TurboCassandra
  module API
    class Attribute
      public

      def find_all
        TurboCassandra::Model::Attribute.all
      end
      def find code
        attribute = TurboCassandra::Model::Attribute.find code
        attribute.to_hash
      end
      def find_by_set_name name
        TurboCassandra::Model::Attribute.find_by attribute_set: name
      end
      def all
        TurboCassandra::Model::Attribute.all
      end
      def find_by_codes codes
        TurboCassandra::Model::Attribute.find_in_by code: codes
      end

      def create attribute_data
        attribute = TurboCassandra::Model::Attribute.new attribute_data
        attribute.save
      end
      def delete code
        TurboCassandra::Model::Attribute.delete code
      end
      def update_attribute code, option
        attribute = TurboCassandra::Model::Attribute.find code
        attribute.options = option
        attribute.save
      end
    end
  end
end
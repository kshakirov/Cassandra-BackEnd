module TurboCassandra
  module Model
    module AttributeSetSql
      def prepare_names_values attribute_set_hash
        return attribute_set_hash.keys.join(","), attribute_set_hash.values.map { |v| '?' }.join(",")
      end

      def prepare_args attribute_set_hash
        attribute_set_hash.values
      end

      def create_insert_cql names, values
        "INSERT INTO attribute_sets  (#{names})  VALUES (#{values})"
      end

      def select_all_cql
        "SELECT * FROM  attribute_sets"
      end

      def select_by_cql name
        "SELECT * FROM  attribute_sets WHERE #{name} = ?"
      end

      def create_update_cql attribute_set_code, attribute_code
        "UPDATE attribute_sets   SET attributes = [ '#{attribute_code}' ] + attributes WHERE code = '#{attribute_set_code}'"
      end

      def create_update_all_cql name
        "UPDATE attribute_sets   SET #{name} = ? WHERE code = ?"
      end
    end
  end
end
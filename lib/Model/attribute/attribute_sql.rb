module TurboCassandra
  module Model
    module AttributeSql
      def remove_null_values attr_properties
        attr_properties.select { |k, v| not v.nil? }
      end

      def prepare_names properties
        properties.keys.map { |k| k.to_s }.join(",")
      end

      def prepare_values properties
        properties.map { |p| '?' }.join(",")
      end

      def prepare_args properties
        properties.values
      end

      def prepare_attributes attr_properties
        properties = remove_null_values(attr_properties)
        return prepare_names(properties), prepare_values(properties), prepare_args(properties)
      end

      def create_insert_cql names, values
        "INSERT INTO attributes  (#{names})  VALUES (#{values})"
      end

      def create_select_where_cql
        "SELECT * from  attributes  WHERE code = ?"
      end

      def create_select_where_in_cql values
        "SELECT * from  attributes  WHERE code IN (#{values})"
      end

      def select_all_cql
        "SELECT * from  attributes "
      end

      def create_select_where_by_set_cql
        "SELECT * from  attributes  WHERE attribute_set=?"
      end
    end
  end
end
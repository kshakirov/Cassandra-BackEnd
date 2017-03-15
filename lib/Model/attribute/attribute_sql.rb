module TurboCassandra
  module Model
    module AttributeSql

      def create_insert_cql names, values
        "INSERT INTO attributes  (#{names})  VALUES (#{values})"
      end

      def create_select_where_cql
        "SELECT * from  attributes  WHERE code = ?"
      end

      def create_delete_where_cql
        "DELETE  from  attributes  WHERE code = ?"
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
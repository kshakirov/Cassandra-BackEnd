module TurboCassandra
  module Model
    class Attribute
      include AttributeSql
      include TurboCassandra::Model::Utils

      def insert attr_properties
        names, values, args = prepare_attributes attr_properties
        cql = create_insert_cql(names, values)
        execute_query(cql, args)
      end

      def find code
        execute_query(create_select_where_cql(), [code])
      end

      def find_by_codes codes
        values = prepare_values codes
        res = execute_query(create_select_where_in_cql(values), codes)
        res.map { |r| r }
      end

      def find_by_set_name name
        execute_query(create_select_where_by_set_cql, [name]).map { |a| a }
      end

      def all
        execute_query(select_all_cql, [])
      end

      def find_all
        execute_query(select_all_cql, []).map { |a| a }
      end

      def delete code
        execute_query(create_delete_where_cql, [code])
        true
      end
    end
  end
end
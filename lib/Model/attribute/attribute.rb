module TurboCassandra
  module Model
    class Attribute
      include AttributeSql

      def insert attr_properties
        names, values, args = prepare_attributes attr_properties
        cql = create_insert_cql(names, values)
        execute(cql, args)
      end

      def find code
        execute(create_select_where_cql(), [code])
      end

      def find_by_codes codes
        values = prepare_values codes
        res = execute(create_select_where_in_cql(values), codes)
        res.map{|r| r}
      end

      def find_by_set_name name
        execute(create_select_where_by_set_cql, [name]).map { |a| a }
      end

      def all
        execute(select_all_cql, [])
      end

      def find_all
        execute(select_all_cql, []).map { |a| a }
      end

      def execute cql, args
        session = TurboCluster.get_session
        statement = session.prepare(cql)
        session.execute(statement, arguments: args, consistency: :one)
      end

    end
  end
end
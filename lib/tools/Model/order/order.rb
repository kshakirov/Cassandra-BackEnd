module TurboCassandra
  module Model
    class Order

      include SqlScheleton
      include TurboCassandra::Model::Utils

      def insert attr_properties
        names, values, args = prepare_attributes! attr_properties
        execute_write(create_cql(names, values), args)
      end

      def get_next_order_id
        ids = execute_select(creat_max_id_cql, [])
        ids.first.values.first.to_i
      end

      def find_by_customer_id id
        execute_select(create_where_customer_id_cql, [id])
      end

      def find_by_id id
        execute_select(create_where_id_cql, [id])
      end

      def _execute cql
        session = TurboCluster.get_session
        return session.prepare(cql), session
      end

      def execute_write cql, args
        statement, session = _execute(cql)
        session.execute(statement, arguments: args, consistency: :any)
      end

      def execute_select cql, args
        statement, session = _execute(cql)
        session.execute(statement, arguments: args)
      end

    end
  end
end
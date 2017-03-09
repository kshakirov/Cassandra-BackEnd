module TurboCassandra
  module Model
    class AttributeSet
      include AttributeSetSql
      def insert attribute_set_hash
        names, values = prepare_names_values attribute_set_hash
        execute(create_insert_cql(names, values), prepare_args(attribute_set_hash))
      end

      def update_attribute_list attribute_set_code, attribute_code
        execute(create_update_cql(attribute_set_code, attribute_code), [])
      end

      def update name, value, code
        execute(create_update_all_cql(name), [value, code])
      end

      def find_all
        execute(select_all_cql, []).map { |a| a }
      end

      def find_by name, value
        execute(select_by_cql(name), [value]).map { |a| a }
      end

      def execute cql, args
        session = TurboCluster.get_session
        statement = session.prepare(cql)
        session.execute(statement, arguments: args, consistency: :one)
      end
    end
  end
end
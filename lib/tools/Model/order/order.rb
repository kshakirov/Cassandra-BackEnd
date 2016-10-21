module TurboCassandra

  class Order

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

    def create_cql names, values
      "INSERT INTO orders  (#{names})  VALUES (#{values})"
    end

    def create_where_id_cql
      "SELECT * FROM orders  WHERE customer_id=? "
    end

    def insert attr_properties
      names, values, args = prepare_attributes attr_properties
      execute_write(create_cql(names, values), args)
    end

    def find_by_customer_id id
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
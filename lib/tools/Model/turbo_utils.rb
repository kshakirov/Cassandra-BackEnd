module TurboCassandra
  module Utils

    def prepare_names hash
      hash.keys.map { |k| k.to_s }.join(",")
    end

    def prepare_values values
      values.map { |v| "?" }.join(",")
    end

    def prepare_args hash
      hash.values
    end

    def prepare_attributes hash
      return prepare_names(hash),
          prepare_values(hash), prepare_args(hash)
    end

    def execute_query cql, args
      session = TurboCluster.get_session
      statement = session.prepare(cql)
      session.execute(statement, arguments: args, consistency: :one)
    end
  end
end
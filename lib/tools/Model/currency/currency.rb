module TurboCassandra
  class Currency
    private
    def prepare_names hash
      hash.keys.map{|k| k.to_s}.join(",")
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

    def select_all_cql
      "SELECT * from  currencies"
    end

    def create_insert_cql names, values
      "INSERT INTO currencies  (#{names}) " \
            "VALUES (#{values})"
    end

    public
    def insert hash
      names, values, args = prepare_attributes(hash)
      execute(create_insert_cql(names, values), args)
    end

    def all
      execute(select_all_cql, [])
    end

    private
    def execute cql, args
      session = TurboCluster.get_session
      statement = session.prepare(cql)
      session.execute(statement, arguments: args, consistency: :one)
    end
  end
end
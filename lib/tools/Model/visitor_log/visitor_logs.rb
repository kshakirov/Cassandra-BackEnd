module TurboCassandra
  module Tools
    def prepare_names properties
      properties.keys.map { |k| k.to_s }.join(",")
    end

    def prepare_values properties
      properties.map { |p| '?' }.join(",")
    end


    def prepare_args properties
      properties.values
    end

    def prepare_attributes hash
      return prepare_names(hash),
          prepare_values(hash), prepare_args(hash)
    end
  end
  class VisitorLog
    include Tools

    private
    def create_insert_cql names, values
      "INSERT INTO visitor_logs  (#{names}) " \
            "VALUES (#{values})"
    end

    def create_select_last name
      "SELECT * FROM visitor_logs WHERE #{name}=?  order by date Desc"
    end

    def execute cql, args
      session = TurboCluster.get_session
      statement = session.prepare(cql)
      session.execute(statement, arguments: args, consistency: :one)
    end

    public

    def insert hash
      names, values, args = prepare_attributes(hash)
      execute(create_insert_cql(names, values), args)
    end

    def last  pair
        execute(create_select_last(pair[:key]),  pair[:value])
    end
  end
end
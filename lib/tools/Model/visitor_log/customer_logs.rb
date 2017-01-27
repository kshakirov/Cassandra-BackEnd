module TurboCassandra


  class CustomerLog
    include Tools

    private
    def create_insert_cql names, values
      "INSERT INTO customer_logs  (#{names}) " \
            "VALUES (#{values})"
    end

    def create_select_last name
      "SELECT * FROM customer_logs WHERE #{name}=?  order by date Desc"
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
      execute(create_select_last(pair[:key]),  [pair[:value]])
    end
  end
end
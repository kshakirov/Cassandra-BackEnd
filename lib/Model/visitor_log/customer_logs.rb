module TurboCassandra
  class CustomerLogOld
    include Tools

    private
    def create_insert_cql names, values
      "INSERT INTO customer_logs  (#{names}) " \
            "VALUES (#{values})"
    end

    def create_select_last name
      "SELECT * FROM customer_logs WHERE #{name}=?  order by date Desc Limit 5"
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

  module Model
    class CustomerLog < BaseModel
    end
    CustomerLog.primary_index = %W(customer_id date id ip)
  end
end
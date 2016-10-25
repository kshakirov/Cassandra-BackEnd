module TurboCassandra
  class GroupPrice
    def prepare_names hash
      hash.keys.map{|k| k.to_s}.join(",")
    end

    def prepare_values values
      values.map{|v| "?" }.join(",")
    end
    def create_insert_cql names, values
      "INSERT INTO group_prices  (#{names}) " \
            "VALUES (#{values})"
    end

    def create_select_where_sku_cql
      "SELECT  * FROM group_prices  WHERE sku=?"
    end

    def prepare_attributes hash
      return prepare_names(hash), prepare_values(hash.values), hash.values
    end

    def insert hash
      names, values, args = prepare_attributes(hash)
      execute(create_insert_cql(names,values), args)
    end

    def find sku
      c = execute(create_select_where_sku_cql, [sku])
      c.first
    end

    def execute cql, args
      session = TurboCluster.get_session
      statement = session.prepare(cql)
      session.execute(statement, arguments: args, consistency: :one)
    end
  end
end
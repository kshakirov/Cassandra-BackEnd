module TurboCassandra
  class Customer

    def get_rid_of_null values
        values.map{|v|
             if v.class.name == 'Hash'
               v.compact
             else
               v
             end
        }
    end

    def prepare_key_values hash
        names  = hash.select{|k,v| not k == 'id'}.compact
        set_names =  names.keys.map{|n| n + " = ?"}.join(',')
        return set_names, get_rid_of_null(names.values)  + [hash['id']]
    end

    def prepare_names hash
      hash.keys.map{|k| k.to_s}.join(",")
    end

    def prepare_values values
      values.map{|v| "?" }.join(",")
    end

    def prepare_args hash
          hash.values
    end

    def prepare_attributes hash
      return prepare_names(hash),
          prepare_values(hash), prepare_args(hash)
    end

    def create_insert_cql names, values
      "INSERT INTO customers  (#{names}) " \
            "VALUES (#{values})"
    end

    def create_select_where_email_cql
      "SELECT  * FROM customers  WHERE email=?"
    end

    def create_select_where_id_cql
      "SELECT  * FROM customers  WHERE id=?"
    end

    def create_select_all_cql
      "SELECT  * FROM customers"
    end

    def create_update_sql  key_values
      "UPDATE customers SET  #{key_values} WHERE id = ?"
    end


    def insert hash
      names, values, args = prepare_attributes(hash)
      execute(create_insert_cql(names,values), args)
    end

    def update hash
      key_values, args  = prepare_key_values(hash)
      execute(create_update_sql(key_values), args)
    end

    def find id
      c = execute(create_select_where_id_cql, [id])
      c.first
    end

    def find_by_email email
      c = execute(create_select_where_email_cql, [email])
      c.first
    end

    def find_all
      c = execute(create_select_all_cql, [])
      c.map{|customer| customer}
    end

    def execute cql, args
      session = TurboCluster.get_session
      statement = session.prepare(cql)
      session.execute(statement, arguments: args, consistency: :one)
    end
  end

end
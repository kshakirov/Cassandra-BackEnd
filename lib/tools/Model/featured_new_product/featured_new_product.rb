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
  end

  class FeaturedProduct
    include TurboCassandra::Utils

    def select_all_cql
      "SELECT * from  featured_products"
    end

    def create_insert_cql names, values
      "INSERT INTO featured_products  (#{names}) " \
            "VALUES (#{values})"
    end

    def execute cql, args
      session = TurboCluster.get_session
      statement = session.prepare(cql)
      session.execute(statement, arguments: args, consistency: :one)
    end

    def all
      execute(select_all_cql, [])
    end

    def insert hash
      names, values, args = prepare_attributes(hash)
      p names, values, args
      execute(create_insert_cql(names, values), args)
    end
  end

  class NewProduct
    include TurboCassandra::Utils

    def select_all_cql
      "SELECT * from  new_products"
    end

    def create_insert_cql names, values
      "INSERT INTO new_products  (#{names}) " \
            "VALUES (#{values})"
    end

    def execute cql, args
      session = TurboCluster.get_session
      statement = session.prepare(cql)
      session.execute(statement, arguments: args, consistency: :one)
    end

    def all
      execute(select_all_cql, [])
    end

    def insert hash
      names, values, args = prepare_attributes(hash)
      execute(create_insert_cql(names, values), args)
    end

  end

end
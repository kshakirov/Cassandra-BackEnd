module TurboCassandra
  module Model
    module Utils

      def remove_null_values attr_properties
        attr_properties.select { |k, v| not v.nil? }
      end

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

      def prepare_attributes! attr_properties
        properties = remove_null_values(attr_properties)
        return prepare_names(properties), prepare_values(properties), prepare_args(properties)
      end

      def execute_query cql, args
        session = TurboCluster.get_session
        statement = session.prepare(cql)
        session.execute(statement, arguments: args, consistency: :one)
      end

      def execute_query_inconsistent cql, args
        session = TurboCluster.get_session
        statement = session.prepare(cql)
        session.execute(statement, arguments: args)
      end

      def execute_paginate table='products', paging_state, page_size
        session = TurboCluster.get_session
        session.execute("SELECT * FROM #{table}", page_size: page_size, paging_state: paging_state )
      end

      def compact_objects hashes
        if hashes.class.name == 'Hash'
          hashes.compact!
          Hash[hashes.map { |k, v| [k, remove_null_values(v)] }.flatten]
        elsif hashes.class.name == "Array"
          hashes.map{|hash| remove_null_values(hash)}
        end
        hashes
      end

    end
  end
end






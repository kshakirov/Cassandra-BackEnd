module TurboCassandra
  module Model
    class Customer

      include TurboCassandra::Model::Utils
      include CustomerSql

      private
      def get_next_id
        last_id = execute_query(creat_select_max_id_cql, [])
        last_id.first.values.first
      end

      public

      def insert hash
        names, values, args = prepare_attributes(hash)
        execute_query(create_insert_cql(names, values), args)
      end


      def new hash
        hash['id'] = get_next_id + 1
        update(hash)
      end

      def update hash
        key_values, args = prepare_key_values(hash)
        execute_query(create_update_sql(key_values), args)
        hash['id']
      end

      def find id
        c = execute_query(create_select_where_id_cql, [id])
        c.first
      end

      def find_by_email email
        c = execute_query(create_select_where_email_cql, [email])
        c.first
      end

      def find_all
        c = execute_query(create_select_all_cql, [])
        c.map { |customer| customer }
      end

      def delete id
        c = execute_query(create_delete_where_id, [id])
        true
      end


    end
  end
end
module TurboCassandra
  module Model
    module CustomerSql

      def get_rid_of_null values
        values.map { |v|
          if v.class.name == 'Hash'
            v.compact
          else
            v
          end
        }
      end

      def prepare_key_values hash
        names = hash.select { |k, v| not k == 'id' }.compact
        set_names = names.keys.map { |n| n + " = ?" }.join(',')
        return set_names, get_rid_of_null(names.values) + [hash['id']]
      end


      def creat_select_max_id_cql
        "SELECT  MAX(id) FROM CUSTOMERS"
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

      def create_update_sql key_values
        "UPDATE customers SET  #{key_values} WHERE id = ?"
      end

      def create_delete_where_id
        "DELETE FROM  customers  WHERE id = ?"
      end

    end
  end
end

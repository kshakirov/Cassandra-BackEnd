module TurboCassandra
  module Model
    module  ComparedProductSql

      def create_insert_cql names, values
        "INSERT INTO compared_products  (#{names}) " \
            "VALUES (#{values})"
      end

      def select_by_customer_id_cql
        "SELECT * from  compared_products where customer_id = ?"
      end

      def delete_by_id_sql
        "Delete   from  compared_products where customer_id = ? and product = ?"
      end

    end
  end
end
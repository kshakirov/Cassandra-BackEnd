module TurboCassandra
  module Model
    module SqlScheleton
      def create_cql names, values
        "INSERT INTO orders  (#{names})  VALUES (#{values})"
      end

      def creat_max_id_cql
        "SELECT  MAX(order_id) FROM ORDERS"
      end

      def create_where_customer_id_cql
        "SELECT * FROM orders  WHERE customer_id=? "
      end

      def create_where_id_cql
        "SELECT * FROM orders  WHERE order_id=? "
      end

      def create_select_all_cql
        "SELECT * FROM orders"
      end
    end
  end
end
module TurboCassandra
  module Model
    module GroupPriceSql

      def create_insert_cql names, values
        "INSERT INTO group_prices  (#{names}) " \
            "VALUES (#{values})"
      end

      def create_select_where_sku_cql
        "SELECT  * FROM group_prices  WHERE sku=?"
      end
    end
  end
end
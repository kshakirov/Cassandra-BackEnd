module TurboCassandra
  module Model
    class GroupPrice
      include TurboCassandra::Model::Utils
      include GroupPriceSql

      public
      def insert hash
        names, values, args = prepare_attributes(hash)
        execute_query_inconsistent(create_insert_cql(names, values), args)
      end

      def find sku
        c = execute_query(create_select_where_sku_cql, [sku])
        c.first
      end

      def find_by_sku_group_id sku, group_id
        group = find sku
        unless group.nil?
          group['prices'][group_id]
        end
      end

    end
  end
end
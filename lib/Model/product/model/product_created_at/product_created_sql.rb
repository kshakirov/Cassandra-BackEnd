module TurboCassandra
  module Model
    module ProductCreatedSql
      def create_insert_cql names, values
        "INSERT INTO products_created_at  (#{names}) " \
            "VALUES (#{values})"
      end

      def execute_paginate  paging_state, page_size, manufacturers, part_types
        session = TurboCluster.get_session
        session.execute("SELECT * FROM products_created_at WHERE manufacturer in (#{manufacturers}) AND part_type in (#{part_types})",
                        page_size: page_size, paging_state: paging_state)
      end

      def create_delete_cql
        "DELETE FROM products_created_at WHERE manufacturer=? AND part_type=? AND created_at=?"
      end
    end
  end
end
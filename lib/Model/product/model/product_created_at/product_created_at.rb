module TurboCassandra
  module Model
    class ProductCreatedAt
      include Utils
      include ProductCreatedSql
      private

      public

      def insert product_hash
        names, values, args = prepare_attributes(product_hash)
        execute_query_inconsistent(create_insert_cql(names, values), args)

      end

      def delete manufacturer, part_type, created_at
        execute_query(create_delete_cql, [manufacturer, part_type, created_at])
      end

      def paginate manufacturers, part_types, page_size=10, paging_state=nil
          manufacturers_list = prepare_ins(manufacturers)
          part_types_list = prepare_ins(part_types)
          rs = execute_paginate paging_state, page_size, manufacturers_list, part_types_list
          {
              results: rs.map{|r| r},
              last: rs.last_page?,
              paging_state: rs.paging_state
          }
      end
    end
  end
end
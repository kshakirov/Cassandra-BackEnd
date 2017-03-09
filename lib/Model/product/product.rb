module TurboCassandra
  module Model
    class Product
      include ProductSql
      include Utils
      private

      public

      def each &block
        result = start_iteration
        loop do
          result.each do |row|
            yield row
          end
          break if result.last_page?
          result = result.next_page
        end
      end

      def find sku
        execute_query(create_select_where_cql, sku)
      end

      def where skus
        execute_query(create_select_where_in_cql(prepare_values(skus)), skus)
      end

      def start_iteration
        session = TurboCluster.get_session
        session.execute("SELECT * FROM products", page_size: 5)
      end

      def insert product_hash
        names, values, args = prepare_attributes(product_hash)
        execute_query_inconsistent(create_insert_cql(names, values), args)
      end

      def paginate paging_state, page_size
        rs = execute_paginate "products", paging_state, page_size
        {
            results: rs.map{|r| r},
            last: rs.last_page?,
            paging_state: rs.paging_state
        }
      end



    end
  end
end
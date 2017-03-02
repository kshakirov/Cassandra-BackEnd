module TurboCassandra
  module Model
    module OrderProduct
      def find_orders_by_product sku
        execute_query_inconsistent(product_order_select_cql, [sku])
      end

      def find_products_by_order order_id
        execute_query_inconsistent(order_product_select_cql, [order_id])
      end

      def insert_product_order attr_properties
        names, values, args = prepare_attributes! attr_properties
        execute_query(product_order_insert_cql(names, values), args)
      end
      def insert_order_product attr_properties
        names, values, args = prepare_attributes! attr_properties
        execute_query(order_product_insert_cql(names, values), args)
      end

    end
  end
end
module TurboCassandra
  module Model
    module OrderProduct
      def order_product_insert_cql names, values
        "INSERT INTO order_products  (#{names})  VALUES (#{values})"
      end
      def product_order_insert_cql names, values
        "INSERT INTO product_orders  (#{names})  VALUES (#{values})"
      end
      def order_product_select_cql
        "SELECT * FROM order_products  WHERE order_id=? "
      end
      def product_order_select_cql
        "SELECT * FROM product_orders  WHERE sku=? "
      end
    end
  end
end
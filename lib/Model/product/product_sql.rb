module TurboCassandra
  module Model
    module ProductSql

      def create_insert_cql names, values
        "INSERT INTO products  (#{names}) " \
            "VALUES (#{values})"
      end

      def create_select_where_cql
        "SELECT * FROM  products  WHERE sku=?"
      end

      def create_select_where_in_cql values
        "SELECT * FROM  products  WHERE sku IN (#{values})"
      end

      def prepare_attributes product_hash
        return prepare_names(product_hash),
            prepare_values(product_hash), prepare_args(product_hash)
      end

      def update_attribute_list attribute_set_code, attribute_code
        "UPDATE attribute_sets   SET attributes = [ '#{attribute_code}' ] + attributes WHERE code = '#{attribute_set_code}'"
      end
    end
  end
end